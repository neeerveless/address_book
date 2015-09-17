package AddressBook::Web::Model::AddressBook;
use strict;
use warnings;
use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config( 
    class       => 'AddressBook::Web::Api::AddressBook',
    constructor => 'new',
);

1;
