package DBIx::Skinny::Cookbook::Util::DBIC;

use strict;
use warnings;
use base 'DBIx::Skinny::Cookbook::Util::Schema';

sub _connect { return <<'CODE';
  my $db = DBIx::Skinny::Cookbook::Model::DBIC->connect(@connect_info{qw/dsn user pass/});
  my $dbh = $db->storage->dbh;
CODE
}

sub _get_iterator {
  my $self = shift;
  my $code = '';
  $code .= 'local $ENV{DBIC_TRACE} = 1;' if $self->{debug};
}

sub _fetch_rows { return <<'CODE';
  my @rows;
  while (my $row = $rs->next) {
    push @rows, {$row->get_columns};
  }
  return @rows ? \@rows : undef;
CODE
}

package DBIx::Skinny::Cookbook::Model::DBIC::Result::Author;
use base 'DBIx::Class::Core';
__PACKAGE__->table('author');
__PACKAGE__->add_columns(qw/id name email/);
__PACKAGE__->set_primary_key('id');

package DBIx::Skinny::Cookbook::Model::DBIC::Result::Dist;
use base 'DBIx::Class::Core';
__PACKAGE__->table('dist');
__PACKAGE__->add_columns(qw/id author_id name version/);
__PACKAGE__->set_primary_key('id');

package DBIx::Skinny::Cookbook::Model::DBIC;
use base 'DBIx::Class::Schema';
for (qw/Dist Author/) {
  my $source = "DBIx::Skinny::Cookbook::Model::DBIC::Result::$_";
  __PACKAGE__->register_class($_ => $source->new);
}

1;

__END__

=head1 NAME

DBIx::Skinny::Cookbook::Util::DBIC

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
