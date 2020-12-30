use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;

=name

Nano::Types

=cut

=tagline

Type Library

=abstract

Type Library

=cut

=synopsis

  package main;

  use Nano::Types;

  1;

=cut

=libraries

Types::Standard

=cut

=description

This package provides type constraints for the L<Nano> object persistence
framework.

=cut

=type Cursor

  Cursor

=type-library Cursor

Nano::Types

=type-composite Cursor

  InstanceOf["Zing::Cursor"]

=type-parent Cursor

  Object

=type-example-1 Cursor

  # given: synopsis

  use Zing::Cursor;
  use Zing::Lookup;

  my $cursor = Zing::Cursor->new(lookup => Zing::Lookup->new(name => 'users'));

=cut

=type Domain

  Domain

=type-library Domain

Nano::Types

=type-composite Domain

  InstanceOf["Zing::Domain"]

=type-parent Domain

  Object

=type-example-1 Domain

  # given: synopsis

  use Zing::Domain;

  my $domain = Zing::Domain->new(name => 'user-12345');

=cut

=type Env

  Env

=type-library Env

Nano::Types

=type-composite Env

  InstanceOf["Zing::Env"]

=type-parent Env

  Object

=type-example-1 Env

  # given: synopsis

  use Zing::Env;

  my $env = Zing::Env->new;

=cut

=type Lookup

  Lookup

=type-library Lookup

Nano::Types

=type-composite Lookup

  InstanceOf["Zing::Lookup"]

=type-parent Lookup

  Object

=type-example-1 Lookup

  # given: synopsis

  use Zing::Lookup;

  my $lookup = Zing::Lookup->new(name => 'users');

=cut

=type Nano

  Nano

=type-library Nano

Nano::Types

=type-composite Nano

  InstanceOf["Nano"]

=type-parent Nano

  Object

=type-example-1 Nano

  # given: synopsis

  use Nano;

  my $nano = Nano->new;

=cut

=type Node

  Node

=type-library Node

Nano::Types

=type-composite Node

  InstanceOf["Nano::Node"]

=type-parent Node

  Object

=type-example-1 Node

  # given: synopsis

  use Nano::Node;

  my $node = Nano::Node->new;

=cut

=type Nodes

  Nodes

=type-library Nodes

Nano::Types

=type-composite Nodes

  InstanceOf["Nano::Nodes"]

=type-parent Nodes

  Object

=type-example-1 Nodes

  # given: synopsis

  use Nano::Nodes;

  my $nodes = Nano::Nodes->new;

=cut

=type Search

  Search

=type-library Search

Nano::Types

=type-composite Search

  InstanceOf["Nano::Search"]

=type-parent Search

  Object

=type-example-1 Search

  # given: synopsis

  use Nano::Nodes;
  use Nano::Search;

  my $search = Nano::Search->new(nodes => Nano::Nodes->new);

=cut

package main;

BEGIN {
  $ENV{ZING_STORE} = 'Zing::Store::Hash';
}

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

ok 1 and done_testing;
