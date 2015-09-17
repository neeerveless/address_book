package AddressBook::Web::Util::DateUtil;

use strict;
use warnings;
use utf8;
use parent qw/Exporter/;
use parent 'DateTime';
use DateTime;
use DateTime::Format::MySQL;
use AddressBook::Web::Util::ConfigLoader qw/load/;

our @EXPORT_OK = qw/create_date now get_birthday_term/;

use constant {
    ONLY_NUM_FORMAT => '%Y%m%d',
    JP_FORMAT       => '%Y年%m月%d日',
    TIME_ZONE       => load('addressbook_web.yml')->{time_zone},
};

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    return bless ($_[0], $class) if (ref $_[0] eq 'DateTime');
    if (ref $_[0] eq 'HASH') {
        return bless (DateTime->new(%{$_[0]}, %{(TIME_ZONE)}), $class);
    }
    elsif (not defined $_[0]) {
        return bless (DateTime->now(%{(TIME_ZONE)}), $class);
    }
}

sub _now {
    return AddressBook::Web::Util::DateUtil->new();
}

sub get_birthday_term {
    my $age = shift;
    my $now = _now();
    warn $now->format_only_num_date;
    warn $now->subtract(years => $age)->format_only_num_date;
    warn $age;
    # my $start_day = $now->subtract(year => ($age + 1));
    # my $last_day  = $now->subtract(year => $age);
    # 上記の用に書きたかったが、インスタンスから引かれてしまうので$ageを2回引いてしまう
    my $last_day  = $now->subtract(years => $age)->format_only_num_date;
    my $start_day = $now->subtract(years => 1)->format_only_num_date;
    return {start => $start_day, last =>$last_day};
}

sub format_mysql_date {
    my $self = shift;
    no strict;
    return DateTime::Format::MySQL->format_date($self);
}

sub format_only_num_date {
    my $self = shift;
    no strict;
    return $self->strftime(ONLY_NUM_FORMAT);
}

sub format_jp_date {
    my $self = shift;
    no strict;
    return $self->strftime(JP_FORMAT);
}

sub split {
    my $self = shift;
    no strict;
    return ($self->year, $self->month, $self->day);
}

sub to_age {
    my $self = shift;
    my $birthday = $self->format_only_num_date;
    my $now_str = $self->new(DateTime->now(%{(TIME_ZONE)}))->format_only_num_date;
    return int(($now_str - $birthday) / 10000);
}

1;
