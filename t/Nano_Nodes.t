use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;

=name

Nano::Nodes

=cut

=abstract

Persistable Index Super Class

=cut

=includes

method: add
method: all
method: count
method: del
method: drop
method: first
method: get
method: last
method: next
method: prev
method: scope
method: search
method: serialize
method: set

=cut

=synopsis

  use Nano::Nodes;

  my $nodes = Nano::Nodes->new(
    type => 'Nano::Node',
  );

  # $nodes->save;

=cut

=libraries

Nano::Types

=cut

=inherits

Nano::Node

=cut

=attributes

scopes: ro, opt, ArrayRef[CodeRef]
type: ro, req, Str

=cut

=description

This package provides a persistable index super class. It is meant to be
subclassed but can be used directly as well.

=cut

=method add

The add method creates a new object, adds it to the index, and returns the
created object.

=signature add

add(HashRef $data) : Object

=example-1 add

  # given: synopsis

  my $node = $nodes->add({ rand => time });

=cut

=method all

The all method proxies to the attached L<Nano::Search> instance and returns the
results.

=signature all

all() : ArrayRef[Object]

=example-1 all

  # given: synopsis

  my $all = $nodes->all;

=cut

=method count

The count method proxies to the attached L<Nano::Search> instance and returns
the results.

=signature count

count() : Int

=example-1 count

  # given: synopsis

  my $count = $nodes->count;

=cut

=method del

The del method removes the object from the index and returns the object (if
found).

=signature del

del(Str $name) : Maybe[Object]

=example-1 del

  # given: synopsis

  my $result = $nodes->del('0000001');

=cut

=method drop

The drop method deletes the entire index and all of its indices.

=signature drop

drop() : Object

=example-1 drop

  # given: synopsis

  $nodes = $nodes->drop;

=cut

=method first

The first method proxies to the attached L<Nano::Search> instance and returns
the result.

=signature first

first() : Maybe[Object]

=example-1 first

  # given: synopsis

  my $first = $nodes->first;

=cut

=method get

The get method returns the object (based on ID) from the index (if found).

=signature get

get(Str $name) : Maybe[Object]

=example-1 get

  # given: synopsis

  my $result = $nodes->get('0000001');

=cut

=method last

The last method proxies to the attached L<Nano::Search> instance and returns
the result.

=signature last

last() : Maybe[Object]

=example-1 last

  # given: synopsis

  my $last = $nodes->last;

=cut

=method next

The next method proxies to the attached L<Nano::Search> instance and returns
the result.

=signature next

next() : Maybe[Object]

=example-1 next

  # given: synopsis

  my $next = $nodes->next;

=cut

=method prev

The prev method proxies to the attached L<Nano::Search> instance and returns
the result.

=signature prev

prev() : Maybe[Object]

=example-1 prev

  # given: synopsis

  my $prev = $nodes->prev;

=cut

=method scope

The scope method registers a scope (search filter) and returns a new invocant
instance.

=signature scope

scope(CodeRef $callback) : Object

=example-1 scope

  # given: synopsis

  $nodes = $nodes->scope(sub {
    my ($node) = @_;

    !!$node->{active}
  });

=cut

=method search

The search method returns a L<Nano::Search> object associated with the invocant.

=signature search

search() : Search

=example-1 search

  # given: synopsis

  my $search = $nodes->search;

=cut

=method serialize

The serialize method returns a persistence representaton of the invocant.

=signature serialize

serialize() : HashRef

=example-1 serialize

  # given: synopsis

  my $serial = $nodes->serialize;

=cut

=method set

The set method adds the node object provided to the index and returns the
provided object.

=signature set

set(Node $object) : Object

=example-1 set

  # given: synopsis

  use Nano::Node;

  my $node = Nano::Node->new(id => '0000003');

  $node = $nodes->set($node);

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

$subs->example(-1, 'add', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('Nano::Node');
  ok !$result->{rand};

  $result
});

$subs->example(-1, 'all', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

$subs->example(-1, 'count', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);
  is $result, 0;

  $result
});

$subs->example(-1, 'del', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'drop', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'first', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'get', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'last', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'next', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'prev', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'scope', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok @{$result->scopes};

  $result
});

$subs->example(-1, 'search', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('Nano::Search');

  $result
});

$subs->example(-1, 'serialize', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->{'$name'};
  ok $result->{'$data'};
  ok $result->{'$type'};

  $result
});

$subs->example(-1, 'set', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('Nano::Node');
  is $result->id, '0000003';

  $result
});

ok 1 and done_testing;
