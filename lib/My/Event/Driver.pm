package My::Event::Driver;
use common::sense;

use parent qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/irc/);

sub drive {
    my ($self, $event) = @_;
    $self->_send($event->channel, $event->command, $event->message)
}

sub _send {
    my $self = shift;
    my ($channel, $command, $message) = @_;
    $self->irc->send_chan(
        $channel, $command, $channel, $message
    );
}

1;
__END__
