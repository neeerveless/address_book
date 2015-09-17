use strict;
use warnings;
use Test::More;


use Catalyst::Test 'AddressBook::Web';
use AddressBook::Web::Controller::AddressBook;

ok( request('/addressbook')->is_success, 'Request should succeed' );
done_testing();
