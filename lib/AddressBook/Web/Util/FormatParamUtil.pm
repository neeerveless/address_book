package AddressBook::Web::Util::FormatParamUtil;

use strict;
use warnings;
use parent qw/Exporter/;
use AddressBook::Web::Util::StringUtil qw/delete_space_line_break/;

our @EXPORT_OK = qw/format_param/;

# 分けると処理が追いづらい
sub format_param {
    my $params = shift;
    delete_space_line_break(\$params->{name});
    delete_space_line_break(\$params->{tel});
    delete_space_line_break(\$params->{zip});
    delete_space_line_break(\$params->{address});
}

1;
