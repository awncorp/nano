package Nano;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

use Scalar::Util ();

# VERSION

# ATTRIBUTES

has env => (
  is => 'ro',
  isa => 'Env',
  new => 1,
);

fun new_env($self) {
  require Nano::Env; Nano::Env->new
}

# SUBS

sub _dump {
  my ($data) = @_;

  if (!defined $data) {
    return undef;
  }
  elsif (Scalar::Util::blessed($data)) {
    if ($data->isa('Nano::Node')) {
      return {
        '$node' => $data->save
      };
    }
    else {
      return {
        '$skip' => 1,
      };
    }
  }
  elsif (UNIVERSAL::isa($data, 'ARRAY')) {
    my $copy = [];
    for (my $i = 0; $i < @$data; $i++) {
      $copy->[$i] = _dump($data->[$i]);
    }
    return $copy;
  }
  elsif (UNIVERSAL::isa($data, 'HASH')) {
    my $copy = {};
    for my $key (keys %$data) {
      $copy->{$key} = _dump($data->{$key});
    }
    return $copy;
  }
  elsif (ref($data)) {
    return {
      '$skip' => 1,
    };
  }
  else {
    return $data;
  }
}

sub _load {
  my ($self, $data) = @_;

  if (!defined $data) {
    return undef;
  }
  elsif (UNIVERSAL::isa($data, 'ARRAY')) {
    my $copy = [];
    for (my $i = 0; $i < @$data; $i++) {
      if (ref($data->[$i]) eq 'HASH') {
        next if $data->[$i]{'$skip'};
      }
      $copy->[$i] = _load($self, $data->[$i]);
    }
    return $copy;
  }
  elsif (UNIVERSAL::isa($data, 'HASH')) {
    if (defined($data->{'$node'})) {
      return $self->object($self->term($data->{'$node'})->object($self->env)->recv);
    }
    my $copy = {};
    for my $key (keys %$data) {
      if (ref($data->{$key}) eq 'HASH') {
        next if $data->{$key}{'$skip'};
      }
      $copy->{$key} = _load($self, $data->{$key});
    }
    return $copy;
  }
  else {
    return $data;
  }
}

# METHODS

method dump(Object $object) {
  return _dump({%{($object)}});
}

method find(Str $name) {
  if (my $keyval = $self->keyval($name)) {
    if (my $object = $keyval->recv) {
      return $self->object($object);
    }
  }
  return undef;
}

method hash(Str $name) {
  require Digest::SHA; Digest::SHA::sha1_hex($name);
}

method keyval(Str $name) {
  return $self->env->app->keyval(name => $name);
}

method name(Object $object) {
  return ref($object);
}

method object(HashRef $object) {
  return $self->reify(@{$object}{qw($name $data)});
}

method reify(Str $name, HashRef $data) {
  return Data::Object::Space->new($name)->build($self->_load($data));
}

method table(Str $name) {
  return $self->env->app->table(name => $name, type => 'keyval');
}

method term(Str $term) {
  return $self->env->app->term($term);
}

1;
