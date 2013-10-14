use common::sense;
use AnyEvent;
use AnyEvent::IRC::Client;
use AnyEvent::IRC::Util qw/prefix_nick/;
use List::Util qw/first/;
use Config::PL;

use My::Event::Entity;
use My::Event::Driver;

my $condvar = AnyEvent->condvar;
my $irc     = AnyEvent::IRC::Client->new;
my $driver  = My::Event::Driver->new({irc=>$irc});

my $config         = config_do 'config.pl';
my $server_config  = $config->{server_config};
my $connect_config = $config->{connect_config};

my ($server, $port, $channels) = map { $server_config->{$_} } qw/server port channels/;

# register callback
$irc->reg_cb(connect    => sub { say "connected"});
$irc->reg_cb(registered => sub { say "registered"});
$irc->reg_cb(disconnect => sub { say "disconnect"});
$irc->reg_cb(publicmsg  => \&bot_main);

# join channel
foreach my $channel (@$channels) {
    $irc->send_srv( "JOIN", $channel );
}

sub bot_main {
    my ($irc, $ch, $msg) = @_;
    my $message = $msg->{params}->[1];
    my $channel = first { $ch eq $_ } @$channels;
    my $speaker = prefix_nick($msg->{prefix});
    if ($channel && $message && $speaker) {
        my $event = My::Event::Entity->new({
            command => $msg->{command},
            message => $message,
            speaker => $speaker,
            channel => $channel,
        });
        $driver->drive($event);
    }
};

$irc->connect($server, $port, $connect_config);
$condvar->recv;
