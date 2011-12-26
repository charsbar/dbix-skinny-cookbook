use strict;
use warnings;
use Test::More;
use DBIx::Skinny::Cookbook::Util;

my $recipes = DBIx::Skinny::Cookbook::Util->recipes;

for my $name (keys %$recipes) {
  my %results;

  for my $recipe (@{ $recipes->{$name} }) {
    my $type = $recipe->{opts}->[0];
    my $handler = DBIx::Skinny::Cookbook::Util->prepare($recipe->{opts});
    unless ($handler) {
      diag "$name: requires $type for this test (SKIP)";
      next;
    }

    my $res = $handler->process($recipe->{code});
    ok $res, $res ? "got ".scalar @$res : "got 0";
    note explain($res);
    $results{$type} = $res;
  }
  my $skinny_result = delete $results{Skinny};
  for (keys %results) {
    is_deeply $skinny_result => $results{$_}, "$name: Skinny and $_ got the same result";
  }
}

done_testing;
