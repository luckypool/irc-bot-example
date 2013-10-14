+{
    server_config => {
        server   => '127.0.0.1',
        port     => 6667,
        channels => [qw/
            #bot_test1
            #bot_test2
            #bot_test3
        /],
    },
    connect_config => {
        nick     => 'log_bot',
        real     => 'log_bot',
        password => 'abc',
    },
};
