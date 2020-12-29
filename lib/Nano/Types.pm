package Nano::Types;

use 5.014;

use strict;
use warnings;

use Data::Object::Types::Keywords;

use base 'Data::Object::Types::Library';

extends 'Types::Standard';

# VERSION

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
  name => 'Cursor',
  parent => 'Object',
  validation => is_instance_of('Zing::Cursor'),
};

register {
  name => 'Domain',
  parent => 'Object',
  validation => is_instance_of('Zing::Domain'),
};

register {
  name => 'Env',
  parent => 'Object',
  validation => is_instance_of('Zing::Env'),
};

register {
  name => 'Lookup',
  parent => 'Object',
  validation => is_instance_of('Zing::Lookup'),
};

1;
