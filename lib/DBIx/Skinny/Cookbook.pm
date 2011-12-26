package DBIx::Skinny::Cookbook;

use strict;
use warnings;

our $VERSION = '0.01';

1;

__END__

=head1 NAME

DBIx::Skinny::Cookbook - working (testable) skinny examples

=head1 DESCRIPTION

=head1 RECIPES

=head2 complex where

=over 4

=item DBIx::Skinny (as of 0.0742)

=for Skinny

  my $rs = $db->resultset({
    select => '*',
    from => 'dist',
  });

  $rs->add_complex_where([
    or => [
      and => [
        { name    => { like => 'DBIx%' } },
        { version => { like => '%7%' } },
      ],
    ],
    { name => 'Test-UseAllModules' }
  ]);

  $rs->order({ column => 'name' });

=item DBIx::Class (as of 0.08196)

=for DBIC

  my $rs = $db->resultset('Dist')->search({
    -or => [
      -and => [
        name    => { like => 'DBIx%' },
        version => { like => '%7%' },
      ],
      name => 'Test-UseAllModules',
    ]
  }, {
    order_by => 'name',
  });

=back

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
