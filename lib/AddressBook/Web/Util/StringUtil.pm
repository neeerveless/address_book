package AddressBook::Web::Util::StringUtil;

use strict;
use warnings;
use parent qw/Exporter/;

our @EXPORT_OK = qw/delete_space_line_break/;

sub delete_space {
    my $str = shift;
    $$str =~ s/^\s*(.*?)\s*$/$1/;
}

sub delete_line_break {
    my $str = shift;
    $$str =~ s/(\n|\r|\r\n)//;
}

sub delete_space_line_break {
    my $str = shift;
    delete_space($str);
    delete_line_break($str);
}

1;
