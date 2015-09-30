use v6;

say 'start';

react {
    whenever IO::Socket::Async.listen('localhost', 3000) -> $conn {
        $conn.bytes-supply.tap(
            -> $buf {
                $conn.write($buf);
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
    }
}
