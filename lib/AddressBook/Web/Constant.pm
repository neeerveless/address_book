package AddressBook::Web::Constant;

use strict;
use warnings;
use utf8;
use parent qw/Exporter/;

our @EXPORT = qw/DISABLED_CHAR_IN_NAME DISABLED_CHAR_IN_ADDR ABLE_CHAR_IN_SEX ABLE_CHAR_IN_USED VALID_TEL_FORMAT VALID_ZIP_FORMAT NE_ID NAME SEX BIRTH TEL ADDR COLUMN QUERY PAGE ORDER BY ASC DESC INDEX SEARCH CREATE EDIT MAN FEMALE SORT_COLUM SORT_ORDER IS_NUM/;

use constant {
    DISABLED_CHAR_IN_NAME   => q{^[^(!|"|#|\$|%|&|'|\(|\)|=|\^|~|\\|\||@|`|\[|\{|\]|\}|:|\*|;|\+|_|/|\?|>|,|<)]+$},
    DISABLED_CHAR_IN_ADDR   => q{^[^(!|"|#|\$|%|&|'|\(|\)|=|\^|~|\\|\||@|`|\[|\{|\]|\}|:|\*|;|\+|_|/|\?|>|,|<)]+$},
    ABLE_CHAR_IN_SEX        => q{(0|1)},
    ABLE_CHAR_IN_USED       => q{(0|1)},
    VALID_TEL_FORMAT        => q{0[0-9]{1,4}-[0-9]{1,4}-[0-9]{4}},
    VALID_ZIP_FORMAT        => q{[0-9]{3}-[0-9]{4}},
    NE_ID                   => '!id',
    NAME                    => 'name',
    SEX                     => 'sex',
    BIRTH                   => 'birthday',
    TEL                     => 'tel',
    ADDR                    => 'address',
    COLUMN                  => 'c',
    QUERY                   => 'q',
    PAGE                    => 'p',
    ORDER                   => 'o',
    BY                      => 'b',
    ASC                     => 'asc',
    DESC                    => 'desc',
    INDEX                   => 'index',
    SEARCH                  => 'search',
    CREATE                  => 'post_new',
    EDIT                    => 'post_edit',
    MAN                     => '男性',
    FEMALE                  => '女性',
    SORT_COLUM              => q{^(name|sex|birthday|address)$},
    SORT_ORDER              => q{^(asc|desc)$},
    IS_NUM                  => q{^\d+$},
};

1;
