package AddressBook::Web::Controller::AddressBook;
use Moose;
use utf8;
use namespace::autoclean;
use AddressBook::Web::Util::DateUtil qw/create_date now/;
use AddressBook::Web::Util::StringUtil qw/delete_space_line_break/;
use AddressBook::Web::Constant;
use Switch;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

AddressBook::Web::Controller::AddressBook - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# fetch_address_information
# {{{
sub fetch_address_info: Chained(/) PathPart(addressbook) CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    my $address_info = $self->get_adaptor()->find($id);
    unless ($address_info) {
        $c->res->redirect('/');
        $c->detach;
    }

    $c->stash->{address_info} = $address_info;
}
# }}}

# detail
# {{{
sub detail : Chained(fetch_address_info) PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my $address_info = {$c->stash->{address_info}->get_columns};

    $address_info->{age} =
        $c->stash->{address_info}->_birthday->to_age;
    $address_info->{birthday} =
        $c->stash->{address_info}->_birthday->format_jp_date;

    $c->stash(
        address_info => $address_info,
        template => 'detail.tt2'
    );
}
# }}}

# get_new
# {{{
sub get_new :Path(new) Args(0) GET {
    my ( $self, $c ) = @_;
    my $fdat = $c->flash->{fdat} || {year => '1990', month => '01', day => '01'};

    $c->stash(
        err_msg  => $c->flash->{err_msg},
        fdat     => $fdat,
        template => 'new.tt2'
    );
}
# }}}

# post_new
# {{{
sub post_new :Path(new) Args(0) POST {
    my ( $self, $c ) = @_;

    # パラメータの最初と最後の「空白」を削除する。
    # パラメータの中の「改行」を削除する。
    format_params($c->req->params);

    # バリデーション処理
    $c->forward('validation_address_book');
    # バリデーションエラーがあったら
    if ($c->form->has_error) {
        $c->flash->{err_msg} = $c->form->field_messages('update_or_create_address_book');
        $c->flash->{fdat} = $c->req->params;
        $c->res->redirect($c->uri_for('new'));
        $c->detach;
    }

    # DB書込
    my $address_info = $self->get_adaptor()->create($c->req->params);

    $c->res->redirect($c->uri_for($c->controller('AddressBook')->action_for('detail'), [$address_info->id]));
    $c->detach;
}
# }}}

# get_edit
# {{{
sub get_edit :Chained(fetch_address_info) PathPart(edit) Args(0) GET {
    my ( $self, $c ) = @_;
    my $fdat = $c->flash->{fdat};
    # fdatが偽の時はDBから読み込んだ値をセットする
    unless ($fdat) {
        $fdat = {$c->stash->{address_info}->get_columns};
        ($fdat->{year}, $fdat->{month}, $fdat->{day}) =
            $c->stash->{address_info}->_birthday->split;
    }
    $c->stash(
        err_msg  => $c->flash->{err_msg},
        fdat     => $fdat,
        template => 'edit.tt2'
    );
}
# }}}

# post_edit
# {{{
sub post_edit :Chained(fetch_address_info) PathPart(edit) Args(0) POST {
    my ( $self, $c ) = @_;

    # パラメータの最初と最後の「空白」を削除する。
    # パラメータの中の「改行」を削除する。
    format_params($c->req->params);

    # バリデーション処理
    # 更新の時に自分自身を重複ととらえないためにidのパラメータが必要
    $c->req->params->{id} = $c->stash->{address_info}->id;
    $c->forward('validation_address_book');
    # バリデーションエラーがあったら
    if ($c->form->has_error) {
        $c->flash->{err_msg} = $c->form->field_messages('update_or_create_address_book');
        $c->flash->{fdat} = $c->req->params;
        $c->res->redirect($c->uri_for(
            $c->controller('AddressBook')->action_for('get_edit'),
            [ $c->stash->{address_info}->id ]
        ));
        $c->detach;
    }

    # DB書込
    my $address_info = $self->get_adaptor()->update(
        $c->stash->{address_info},
        $c->req->params
    );

    $c->res->redirect($c->uri_for($c->controller('AddressBook')->action_for('detail'), [$address_info->id]));
    $c->detach;
}
# }}}

# delete
# {{{
sub delete : Chained(fetch_address_info) PathPart('delete') Args(0) {
    my ($self, $c) = @_;
    $self->get_adaptor()->delete($c->stash->{address_info});

    $c->res->redirect($c->req->referer || '/');
    $c->detach;
}
# }}}

# used
# {{{
sub used : Chained(fetch_address_info) PathPart('used') Args(0) {
    my ($self, $c) = @_;

    $self->get_adaptor()->toggle_is_used($c->stash->{address_info});

    $c->res->redirect($c->req->referer || '/');

    $c->detach;
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

# format_params
# {{{
sub format_params {
    my $params = shift;
    delete_space_line_break(\$params->{name});
    delete_space_line_break(\$params->{tel});
    delete_space_line_break(\$params->{zip});
    delete_space_line_break(\$params->{address});
}
# }}}

# create_dbic_uniq
# {{{
sub create_dbic_uniq {
    my $self          = shift;
    my $caller_action = shift;
    my $dbic_uniq;
    switch ($caller_action) {
        case CREATE {
            $dbic_uniq->{name} =
                { dbic_unique => [ qw/name tel/ ] };
            $dbic_uniq->{rule} =
                [ [ 'DBIC_UNIQUE', $self->get_adaptor(), NAME, TEL ] ];
        }
        case EDIT {
            $dbic_uniq->{name} =
                { dbic_unique => [ qw/id name tel/ ] };
            $dbic_uniq->{rule} =
                [ [ 'DBIC_UNIQUE', $self->get_adaptor(), NE_ID, NAME, TEL ] ];
        }
    }
    return $dbic_uniq;
}
# }}}

# validation_address_book
# {{{
sub validation_address_book : Private {
    my ( $self, $c ) = @_;

    # 新規登録の時と更新の時で
    # 重複チェックルールを変える
    my $dbic_uniq= $self->create_dbic_uniq($c->action->name);

    my $now_str   = AddressBook::Web::Util::DateUtil->_now()->format_only_num_date;
    # 誕生日が過去の日付かバリデーションするために
    # year,month,dayをそれぞれすると面倒なので'birthday'というパラメータを作成
    # バリデーション前なのでDateTimeオブジェクト作ろうとすると死ぬときがあるので
    # joinでやります。
    my $birthday  = join '', @{$c->req->params}{qw/year month day/};
    $c->req->param(BIRTH, $birthday);

    # パラメータのyear,month,dayをまとめてバリデーションするために
    my $birthday_format = { birthday_format => [ qw/year month day/ ] };
    
    $c->form(
        name                => [ qw/NOT_BLANK/, [ qw/JLENGTH 1 32/ ], [ 'REGEX', DISABLED_CHAR_IN_NAME ] ],
        $birthday_format    => [ 'DATE' ],
        birthday            => [ [ 'LESS_THAN', $now_str ] ],
        sex                 => [ qw/NOT_BLANK/, [ 'REGEX', ABLE_CHAR_IN_SEX ] ],
        tel                 => [ qw/NOT_BLANK/, [ qw/LENGTH 12 13/ ], [ 'REGEX', VALID_TEL_FORMAT ] ],
        zip                 => [ qw/NOT_BLANK/, [ qw/LENGTH 8/ ], [ 'REGEX', VALID_ZIP_FORMAT ] ],
        address             => [ qw/NOT_BLANK/, [ qw/JLENGTH 1 255/ ], [ 'REGEX', DISABLED_CHAR_IN_ADDR ] ],
        $dbic_uniq->{name}  => $dbic_uniq->{rule}
    );
}
# }}}

=encoding utf8

=head1 AUTHOR

mshr

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
