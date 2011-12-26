package DBIx::Skinny::Cookbook::Util;

use strict;
use warnings;
use DBIx::Skinny::Cookbook;
use File::Spec;

sub recipes {
  my ($class, @wanted) = @_;
  my $parser = DBIx::Skinny::Cookbook::Util::Parser->new;
  if (@wanted) {
    $parser->context(wanted => { map { $_ => 1 } @wanted });
  }

  my @recipes;
  $parser->context(callback => sub {
    my ($context, $args) = @_;
    push @{ $context->{recipes}{$args->{name}} ||= [] }, $args;
  });
  $parser->parse_from_file($INC{'DBIx/Skinny/Cookbook.pm'});

  return $parser->context->{recipes};
}

sub prepare {
  my ($class, $opts) = @_;
  return if !$opts or ref $opts ne ref [];

  my $basename = shift @$opts or return;
  my $handler_class = __PACKAGE__.'::'.$basename;
  eval "require $handler_class" or do { die $@ if $@; return };

  my %args;
  for (@$opts) {
    if (/:/) {
      my ($key, $value) = split /:/, $_;
      $args{$key} = $value;
    }
    else {
      $args{$_} = 1;
    }
  }

  $args{debug} = 1 if $ENV{TEST_VERBOSE};

  $handler_class->new(%args);
}

package #
  DBIx::Skinny::Cookbook::Util::Parser;

use strict;
use warnings;
use base 'Pod::Parser';

sub command {
  my ($parser, $command, $paragraph, $line_num) = @_;

  my $context = $parser->context;

  if ($command eq 'head1') {
    if ($paragraph =~ /^RECIPES\b/) {
      $context->{in_recipes} = 1;
    }
    else {
      $context->{in_recipes} = 0;
    }
  }
  return unless $context->{in_recipes};

  if ($command eq 'head2') {
    my $recipe = (split /\n/, $paragraph)[0];
    $recipe =~ s/ /_/g;

    return if $context->{wanted} && !$context->{wanted}{$recipe};

    $context->{current} = $recipe;
  }
  return unless $context->{current};

  if ($command =~ /^(?:over|item|back)$/) {
    if (my $args = delete $context->{args}) {
      $args->{name} = $context->{current};
      $context->{callback}->($context, $args);
    }
  }
  if ($command eq 'for') {
    $context->{args}{opts} = [split / /, (split /\n/, $paragraph)[0]];
  }
  return;
}

sub verbatim {
  my ($parser, $paragraph, $line_num) = @_;

  my $context = $parser->context;

  return unless $context->{current};

  $context->{args}{code} ||= '';
  $context->{args}{code} .= $paragraph;
}

sub textblock { return }

sub context {
  my $parser = shift;

  if (@_) {
    my %args = @_;
    $parser->{context}{$_} = $args{$_} for keys %args;
  }
  $parser->{context};
}

1;

__END__

=head1 NAME

DBIx::Skinny::Cookbook::Util

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 recipes

=head2 prepare

=head1 INTERNAL USE ONLY

=head2 command, verbatim, textblock

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
