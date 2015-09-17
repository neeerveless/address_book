package AddressBook::Web::View::TT;
use Moose;
use namespace::autoclean;
use Template::AutoFilter;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

AddressBook::Web::View::TT - TT View for AddressBook::Web

=head1 DESCRIPTION

TT View for AddressBook::Web.

=head1 SEE ALSO

L<AddressBook::Web>

=head1 AUTHOR

mshr

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
