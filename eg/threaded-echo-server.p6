use v6;
use NativeCall;

# threaded の echoserver を無理やり実装してみた例｡
# THIS IS JOKE.

constant $SOCK_STREAM = 1;
constant $AF_INET = 2;

constant $INADDR_ANY = 0;

sub fork () returns Int is native { ... }

my class sockaddr_in is repr('CStruct') {
    has int16  $.sin_family is rw; # sa_family_t
    has uint16 $.sin_port   is rw;
    has uint32 $.sin_addr     is rw;
    has uint64 $.dummy;

    method pack_sockaddr_in($port, $ip_address) {
        my $addr = sockaddr_in.new();
        $addr.sin_family = $AF_INET;
        $addr.sin_port = htons($port);
        $addr.sin_addr = $ip_address;
        return $addr;
    }
}


my module private {
    our sub wait(CArray[int]) returns Int is native { ... }
    our sub waitpid(Int $pid, CArray[int] $status, Int $options)
        returns Int is native { ... }
    our sub bind(int $sockfd, sockaddr_in $addr, int32 $len)
        returns int
        is native { }
    our sub accept(int $sockfd, sockaddr_in $addr, CArray[int32] $len)
        returns int
        is native { }
    our sub send(int $sockfd, Blob $buf, uint64 $len, int $flags)
        returns int64
        is native { ... };
    our sub recv(int $sockfd, buf8 $buf, uint64 $len, int $flags)
        returns int64
        is native { ... };
}

sub socket(Int $domain, Int $type, Int $protocol)
    returns Int is native { ... }

sub wait() {
    my $status = CArray[int].new;
    $status[0] = 0;
    my $pid = private::wait($status);
    return ($pid, $status[0]);
}

sub perror(Str $s)
    returns Str
    is native { ... };

sub waitpid(Int $pid, Int $options) {
    my $status = CArray[int].new;
    $status[0] = 0;
    my $ret_pid = private::waitpid($pid, $status, $options);
    return ($ret_pid, $status[0]);
}

sub bind(int $sock-fd, sockaddr_in $addr) {
    return private::bind($sock-fd, $addr, 16);
}

sub htons(uint16 $hostshort)
    returns uint16
    is native { ... };

sub listen(int $sockfd, int $backlog)
    returns int
    is native { ... };

# int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
sub accept(int $sockfd, sockaddr_in $sockaddr) {
    my $len = CArray[int32].new;
    $len[0] = 16;
    return private::accept($sockfd, $sockaddr, $len);
}

sub inet_ntoa(int32 $sockaddr)
    returns Str
    is native
    { ... }

sub ntohs(uint16 $sockaddr)
    returns uint16
    is native
    { ... }

sub close(int $fd)
    returns int
    is native { ... }

sub send(int $sockfd, Blob $buf, int $flags) {
    return private::send($sockfd, $buf, $buf.elems, $flags);
}

sub recv(int $sockfd, Buf $buf, int64 $len, int $flags) {
    return private::recv($sockfd, $buf, $len, $flags);
}

class Raw::Socket::INET {
    has int $.fd;

    has $.listen;
    has $.localhost;
    has $.localport;

    method new(*%args is copy) {
        fail "Nothing given for new socket to connect or bind to" unless %args<host> || %args<listen>;

        fail "client socket does not supported yet" unless %args<listen>;
        self.bless(|%args)!initialize()
    }

    method !initialize() {
        self.socket($SOCK_STREAM, 0);
        self.bind($.localport, $INADDR_ANY);
        self.listen(20);
        return self;
    }

    method socket($type, $protocol) {
        $!fd = socket($AF_INET, $type, $protocol);
        if ($!fd < 0) {
            die "cannot open socket";
        }
    }

    method bind($port, $host) {
        my $sockaddr = sockaddr_in.pack_sockaddr_in($port, $host);
        if (bind($!fd, $sockaddr) != 0) {
            die "cannot bind";
        }
    }

    method listen($backlog) {
        if (listen($!fd, 20) != 0 ) {
            die "cannot listen";
        }
    }

    method accept() {
        my $client_addr = sockaddr_in.new();
        my $clientfd = accept($!fd, $client_addr);
        my $new_sock := $?CLASS.bless(fd => $clientfd);
        return $new_sock;
    }

    method recv(Buf $buf, int64 $len, int $flags) {
        say $!fd;
        return recv($!fd, $buf, $len, $flags);
    }

    method send(Blob $buf, int $flags) {
        return send($!fd, $buf, $flags);
    }

    method close() {
        return close($!fd);
    }
}

# -------------------------------------------------------------------------

sub info($msg as Str) {
    say "[{$*THREAD.id}] $msg";
}

# -------------------------------------------------------------------------

#   my $sock = IO::Socket::INET.new(
#       listen    => True,
#       localport => 9989,
#   );
class Echod {
    has @!threads;
    has $!sock;

    method listen($port) {
        $!sock = Raw::Socket::INET.new(
            listen => True,
            localport => $port,
        );
    }

    method spawn-child() {
        @!threads.push(start {
            self.work();
        });
    }

    method work() {
        while (1) {
            info 'accepting..';
            my $csock = $!sock.accept();
            info "clientfd: $csock";
            # say inet_ntoa($client_addr.sin_addr);
            # say ntohs($client_addr.sin_port);

            my $buf = buf8.new;
            $buf[100-1] = 0; # extend buffer

            loop {
                my $readlen = $csock.recv($buf, 100, 0);
                if ($readlen <= 0) {
                    info("closed");
                    $csock.close();
                    last;
                }
                my $sent = $csock.send($buf.subbuf(0, $readlen), 0);
            }
        }
    }

    method run($n) {
        for 1..$n {
            self.spawn-child();
        }

        for @!threads {
            .join
        }
    }
}

my $port = 0+@*ARGS[0];

say "listening $port";

my $echod = Echod.new();
$echod.listen($port);
$echod.run(10);

