package AddressBook::Web::Api::AddressBook;

use strict;
use warnings;
use utf8;
use AddressBook::Web::Schema;
use AddressBook::Web::Util::ConfigLoader qw/load/;
use AddressBook::Web::Util::DateUtil qw/get_birthday_term/;
use AddressBook::Web::Constant;
use Switch;

sub new {
    my ($class, $args) = @_;
    my $self = { AddressBook =>
        AddressBook::Web::Schema->connect(
            @{load('addressbook_web.yml')->{'Model::DBIC'}->{'connect_info'}},
        )->resultset('AddressBook')
    };
    return bless $self, $class;
}

sub format_birthday_param {
    my $params    = shift;
    my $date_hash = { map { $_ => $params->{$_}; } qw/year month day/ };
    my $birthday  = AddressBook::Web::Util::DateUtil->new($date_hash);

    $params->{birthday} = (BIRTH, $birthday->format_mysql_date);
    delete @$params{qw/year month day/};
    return $params;
}

sub format_sex_query {
    my $query = shift;
    switch ($query) {
        case MAN {
            return 0;
        }
        case FEMALE {
            return 1;
        }
        else {
            return -1;
        }
    }
}

sub create {
    my ($self, $raw_params) = @_;
    my $params = format_birthday_param($raw_params);
    return $self->{AddressBook}->create($params);
}

sub update {
    my ($self, $obj, $raw_params) = @_;
    my $params = format_birthday_param($raw_params);
    return $obj->update($params);
}

sub delete {
    my ($self, $obj) = @_;
    $obj->delete;
}

sub find {
    my ($self, $args) = @_;
    return $self->{AddressBook}->find($args);
}

sub get_all {
    my ($self, $args) = @_;
    my $cond = {};
    return $self->get_entries($cond, $args);
}

sub search {
    my ($self, $cond, $opt) = @_;
    return $self->{AddressBook}->search($cond,$opt);
}

sub count {
    my ($self, $cond, $opt) = @_;
    return $self->search($cond, $opt)->count;
}

sub toggle_is_used {
    my ($self, $obj) = @_;
    # ! boolenみたいにtrue,falseを切り替える
    my $is_used = $obj->is_used == 1 ? 0 : 1;
    $obj->update({is_used => $is_used});
}

sub get_default_search_opt {
    my ($self, $current_page) = @_;
    my %opt = (
        page => $current_page,
        rows => load('addressbook_web.yml')->{pager}->{entries_per_page},
    );
    return %opt;
}

sub get_entries {
    my ($self, $cond, $args) = @_;
    $args->{order} //= 'asc';
    $args->{by}    //= 'name';
    my $opt = {
        $self->get_default_search_opt($args->{current_page}),
        order_by => {"-$args->{order}" => $args->{by}},
    };
    my $result_set = $self->search($cond, $opt);
    return ([$result_set->all], $result_set->pager);
}

sub get_entries_by_name {
    my ($self, $args) = @_;
    my $cond = {name => {like => "%$args->{query}%"}};
    return $self->get_entries($cond,$args);
}

sub get_entries_by_sex {
    my ($self, $args) = @_;
    my $q = format_sex_query($args->{query});
    my $cond = {sex => $q};
    return $self->get_entries($cond,$args);
}

sub get_entries_by_age {
    my ($self, $args) = @_;
    warn 1111111111111111;
    my $birthday_term = get_birthday_term($args->{query});
    warn 2222222222222;
    my $cond = {
        birthday => {
            '>' => $birthday_term->{start},
            '<=' => $birthday_term->{last}
        },
    };

    return $self->get_entries($cond,$args);
}

sub get_entries_by_address {
    my ($self, $args) = @_;
    my $cond = {address => {like => "%$args->{query}%"}};
    return $self->get_entries($cond,$args);
}

1;
