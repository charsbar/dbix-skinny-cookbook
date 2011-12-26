package DBIx::Skinny::Cookbook::Util::Skinny;

use strict;
use warnings;
use base 'DBIx::Skinny::Cookbook::Util::Schema';

sub _connect { return <<'CODE';
  my $db = DBIx::Skinny::Cookbook::Model::Skinny->new({
    dsn      => $connect_info{dsn},
    username => $connect_info{user},
    password => $connect_info{pass},
  });
  my $dbh = $db->dbh;
CODE
}

sub _get_iterator {
  my $self = shift;
  my $code = '';
  $code .= 'warn $rs->as_sql;' if $self->{debug};
  $code .= 'my $iter = $rs->retrieve;';
  $code;
}

sub _fetch_rows { return <<'CODE';
  my @rows;
  while (my $row = $iter->next) {
    push @rows, $row->get_columns;
  }
  return @rows ? \@rows : undef;
CODE
}

package DBIx::Skinny::Cookbook::Model::Skinny::Schema;
use DBIx::Skinny::Schema;

install_table author => schema {
  pk 'id';
  columns qw/id name email/;
};

install_table dist => schema {
  pk 'id';
  columns qw/id author_id name version/;
};

package DBIx::Skinny::Cookbook::Model::Skinny;
use DBIx::Skinny;

1;

__END__

=head1 NAME

DBIx::Skinny::Cookbook::Util::Skinny

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
