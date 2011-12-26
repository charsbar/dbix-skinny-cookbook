use strict;
use warnings;
use Test::More;
use Test::UseAllModules;

my @dbic_only = qw/
  DBIx::Skinny::Cookbook::Util::DBIC
/;
my $has_dbic;

BEGIN { $has_dbic = eval { require DBIx::Class } }

plan tests => Test::UseAllModules::_get_module_list() - ($has_dbic ? 0 : scalar @dbic_only);

all_uses_ok except => @dbic_only;

if ($has_dbic) {
  use_ok $_ for @dbic_only;
}
