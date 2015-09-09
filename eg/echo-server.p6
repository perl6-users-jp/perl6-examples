use v6;

use lib 'lib';

my $sock = IO::Socket::INET.new(
    listen    => True,
    localhost => '127.0.0.1',
    localport => 9989,
);
while my $csock = $sock.accept {
    loop {
        my $buf = $csock.recv(:bin);
        last if $buf.bytes == 0;
        $csock.write($buf);
    }
    $csock.close;
}

=begin END

IO::Socket::INET をつかって､簡単なエコーサーバーを書いてみた例｡

Perl5 で書いたものとほとんど変わりはない｡
一般的なソケットAPIをラップしているだけなので､当たり前ではある｡

