package Nano::Types;

use 5.014;

use strict;
use warnings;

use Data::Object::Types::Keywords;

use base 'Data::Object::Types::Library';

extends 'Types::Standard';

# VERSION

register {
  name => 'Changes',
  parent => 'Object',
  validation => is_instance_of('Nano::Changes'),
};

register {
  name => 'Domain',
  parent => 'Object',
  validation => is_instance_of('Zing::Domain'),
};

register {
  name => 'Env',
  parent => 'Object',
  validation => is_instance_of('Nano::Env'),
};

register {
  name => 'Nano',
  parent => 'Object',
  validation => is_instance_of('Nano'),
};

register {
  name => 'Node',
  parent => 'Object',
  validation => is_instance_of('Nano::Node'),
};

register {
  name => 'Nodes',
  parent => 'Object',
  validation => is_instance_of('Nano::Nodes'),
};

register {
  name => 'Search',
  parent => 'Object',
  validation => is_instance_of('Nano::Search'),
};

register {
  name => 'KeyVal',
  parent => 'Object',
  validation => is_instance_of('Zing::KeyVal'),
};

register {
  name => 'Stash',
  parent => 'Object',
  validation => is_consumer_of('Nano::Stash'),
};

register {
  name => 'Table',
  parent => 'Object',
  validation => is_instance_of('Zing::Table'),
};

register {
  name => 'Track',
  parent => 'Object',
  validation => is_consumer_of('Nano::Track'),
};

1;
