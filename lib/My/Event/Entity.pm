package My::Event::Entity;
use common::sense;

use parent qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/command message speaker channel/);

1;
__END__
