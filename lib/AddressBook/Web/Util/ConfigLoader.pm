package AddressBook::Web::Util::ConfigLoader;

use strict;
use warnings;
use parent qw/Exporter/;
use YAML;
use File::Basename;

our @EXPORT_OK = qw/load/;

sub load {
    my $file_path = shift;
    my $catalyst_home_path = file_path(). '/../../../../';
    return YAML::LoadFile($catalyst_home_path. $file_path);
}

sub file_path {
    return dirname(__FILE__, '');
}

1;
