use utf8;
package AddressBook::Web::Schema::Result::AddressBook;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

AddressBook::Web::Schema::Result::AddressBook

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<address_book>

=cut

__PACKAGE__->table("address_book");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 birthday

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 sex

  data_type: 'tinyint'
  is_nullable: 0

=head2 tel

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 zip

  data_type: 'varchar'
  is_nullable: 0
  size: 8

=head2 address

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 is_used

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "birthday",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "sex",
  { data_type => "tinyint", is_nullable => 0 },
  "tel",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "zip",
  { data_type => "varchar", is_nullable => 0, size => 8 },
  "address",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "is_used",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name>

=over 4

=item * L</name>

=item * L</tel>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name", "tel"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-03 18:05:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RK6isy0DJM4hHeRo8/DOdg
use AddressBook::Web::Util::DateUtil;

sub _birthday {
    my $self = shift;
    return AddressBook::Web::Util::DateUtil->new($self->birthday); 
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
