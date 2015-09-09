use v6;

say "1..1"; # plan 1;

use NativeCall;

sub fork () returns Int is native { ... }

my module private {
    our sub wait(CArray[int]) returns Int is native { ... }
}

sub wait() {
    my $status = CArray[int].new;
    $status[0] = 0;
    my $pid = private::wait($status);
    return ($pid, $status[0]);
}

my $pid = fork();
if ($pid == 0) { # child
    note "i'm child";
    exit 0;
} elsif ($pid > 0) { # parent
    my ($got_pid, $status) = wait();
    say ($got_pid == $pid ?? "ok" !! "not ok") ~ " 1 - pid";
} else {
    die "cannot fork: $!";
}
