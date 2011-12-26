package DBIx::Skinny::Cookbook::Util::Schema;

use strict;
use warnings;
use Perl::Tidy qw/perltidy/;

sub new {
  my ($class, %args) = @_;
  bless \%args, $class;
}

sub process {
  my ($self, $snippet) = @_;

  my $code = 'use strict; use warnings;';
  $code .= <<'CODE';
    my $prefix = "DBIX_SKINNY_COOKBOOK";
    my %connect_info = (
      dsn  => $ENV{$prefix."_DSN"} || "dbi:SQLite::memory:",
      user => $ENV{$prefix."_USER"},
      pass => $ENV{$prefix."_PASS"},
    );
CODE

  $code .= $self->_connect;
  $code .= <<'CODE';
    local $dbh->{sqlite_allow_multiple_statements} = 1;
    $dbh->do(DBIx::Skinny::Cookbook::Util::Schema->schema_sql);
CODE

  $code .= $snippet;

  $code .= $self->_get_iterator;
  $code .= $self->_fetch_rows;

  perltidy(source => \$code, destination => \my $tidied);
  $code = $tidied;

  warn $code if $self->{debug};

  eval "$code" or do { die $@ if $@; return };
}

sub schema_sql { return <<'SCHEMA_SQL';
create table author (
  id integer primary key,
  name text,
  email text
);
create table dist (
  id integer primary key,
  author_id integer,
  name text,
  version text
);
insert into author values(1, 'nekokak',  'nekokak@cpan.org');
insert into author values(2, 'ishigaki', 'ishigaki@cpan.org');
insert into dist values(1, 2, 'DBIx-Skinny',  '0.0742');
insert into dist values(2, 2, 'DBIx-Handler',  '0.04');
insert into dist values(3, 1, 'Test-UseAllModules',  '0.13');
insert into dist values(4, 1, 'Acme-CPANAuthors',  '0.18');
SCHEMA_SQL
}

1;

__END__

=head1 NAME

DBIx::Skinny::Cookbook::Util::Schema

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head2 process

=head2 schema_sql

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
