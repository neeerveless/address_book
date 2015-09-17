use strict;
use warnings;

use AddressBook::Web;

my $app = AddressBook::Web->apply_default_middlewares(AddressBook::Web->psgi_app);
$app;

