package AddressBook::Web::Controller::Root;

use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;

use Switch;
use AddressBook::Web::Api::AddressBook;
use AddressBook::Web::Util::ConfigLoader qw/load/;
use AddressBook::Web::Util::DateUtil;
use AddressBook::Web::Constant;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

AddressBook::Web::Controller::Root - Root Controller for AddressBook::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

# index
# {{{
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $address_book_adaptor = $self->get_adaptor();
    my $params_hash          = acquisition_params($c->req->params);

    # resultsetを受け取って、resultsetからentriesとpageを
    # 取得したかったけど何故かできないのでこの方法で。。。
    my ($address_infos, $page) = $address_book_adaptor->get_all($params_hash);

    map { $_->{age} = $_->_birthday->to_age } @{$address_infos};

    $c->stash(
        %$params_hash,
        asdf => 12345,
        page          => $page,
        address_infos => $address_infos,
        template      => 'index.tt2'
    );
}
# }}}

# search
# {{{
sub search : Local {
    my ( $self, $c ) = @_;
    my $address_book_adaptor = $self->get_adaptor();
    my $params_hash          = acquisition_params($c->req->params);
    my $address_infos;
    my $page;

    if ($params_hash->{query} eq '') {
        ($address_infos, $page) = $address_book_adaptor->get_all($params_hash);
    }
    else {
        # 検索対象による切り替え↓
        # {{{
        switch ($c->req->param(COLUMN)) {
            case NAME {
                ($address_infos, $page) =
                    $address_book_adaptor->get_entries_by_name($params_hash);
            }
            case SEX {
                ($address_infos, $page) =
                    $address_book_adaptor->get_entries_by_sex($params_hash);
            }
            case BIRTH {
                ($address_infos, $page) =
                    $address_book_adaptor->get_entries_by_age($params_hash);
            }
            case ADDR {
                ($address_infos, $page) =
                    $address_book_adaptor->get_entries_by_address($params_hash);
            }
            else {
                $c->res->redirect('/');
                $c->detach;
            }
        }
        # }}}
    }

    map { $_->{age} = $_->_birthday->to_age } @{$address_infos};

    $c->stash(
        %$params_hash,
        page          => $page,
        address_infos => $address_infos,
        template      => 'search.tt2'
    );
}
# }}}

# acquisition
# {{{
sub acquisition_params {
    my $params        = shift;
    my $target_column = $params->{''.COLUMN};
    my $query         = $params->{''.QUERY};
    my $current_page  = $params->{''.PAGE};
    my $order         = $params->{''.ORDER};
    my $by            = $params->{''.BY};
    my $next_order    = $order eq ASC ? DESC : ASC;

    $current_page = $current_page =~ m/${\(IS_NUM)}/ ? $current_page : 1;
    $order        = $order =~ m/${\(SORT_ORDER)}/    ? $order        : ASC;
    $by           = $by =~ m/${\(SORT_COLUM)}/       ? $by           : NAME;

    return {
        current_page => $current_page,
        column       => $target_column,
        query        => $query,
        order        => $order,
        next_order   => $next_order,
        by           => $by,
    };

}
# }}}

# get_adaptor
# {{{
sub get_adaptor {
    my $self = shift;
    if ($self->{adapter}) {
        return $self->{adapter};
    }
    $self->{adapter} = AddressBook::Web::Api::AddressBook->new();
    return $self->{adapter};
}
# }}}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->res->redirect('/');
    $c->detach;
}

=head2 end

Attempt to render a view, if needed.

=cut
sub end : Private {
    my ( $self, $c ) = @_;
    $c->forward('render') unless $c->response->body;
    $c->fillform($c->stash->{fdat});
}
sub render : ActionClass('RenderView') {}

=head1 AUTHOR

mshr

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
