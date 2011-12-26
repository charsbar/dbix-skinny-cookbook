use strict;
use warnings;
use ExtUtils::MakeMaker;

my %params = (
  NAME          => 'DBIx::Skinny::Cookbook',
  AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM  => 'lib/DBIx/Skinny/Cookbook.pm',
  ABSTRACT_FROM => 'lib/DBIx/Skinny/Cookbook.pm',
  LICENSE       => 'perl',
  PREREQ_PM     => {
    'DBI'                 => '1.609',
    'DBIx::Skinny'        => '0.0742',
    'DBD::SQLite'         => '1.33',
    'File::Spec'          => 0,
    'Perl::Tidy'          => 0,
    'Pod::Parser'         => 0,
    'Test::More'          => '0.47',
    'Test::UseAllModules' => '0.10',
  },
  META_MERGE => {
    resources => {
      repository => 'git://github.com/charsbar/dbix-skinny-cookbook',
    },
  },
);

my $eumm = $ExtUtils::MakeMaker::VERSION;
delete $params{LICENSE}    if $eumm < 6.31;
delete $params{META_MERGE} if $eumm < 6.46;

WriteMakefile(%params);
