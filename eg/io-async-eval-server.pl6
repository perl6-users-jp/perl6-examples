use v6;

say 'start';

my $resp-chan = Channel.new;
my $req-chan = Channel.new;

sub info($msg) {
    say "{$*THREAD.id} $msg";
}

my sub eval-code(Str $code) {
    CATCH { return $_.perl }
    return EVAL($code).perl;
}

Thread.start({
    loop {
        info("waiting child");
        my ($req, $csock) = @($req-chan.receive);
        $csock.perl.say;
        info("received");
        my $result = eval-code($req.decode('utf-8'));
        info("result: {$result}");
        $resp-chan.send([$result, $csock]);
    }
});

react {
    say "listen 3000";
    my $sock = IO::Socket::Async.listen('localhost', 3000);
    $sock.tap(-> $conn {
        info("conn");
        $conn.bytes-supply.tap(
            -> $buf {
                info("got");
                $req-chan.send([$buf, $conn]);
            },
            done => {
                say "DONE";
            },
            closing => {
                say "CLOSING";
            },
            quit => {
                say "QUIT";
            }
        );
        info("next.");
    });

    loop {
        my ($got, $csock) = @($resp-chan.receive);

        info("sending result: " ~ $got);
        $csock.write(($got ~ "\n").encode('utf-8')).then({
            $csock.close;
        });

        CATCH { .say }
    }
};

