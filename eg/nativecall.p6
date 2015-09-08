use v6;
use NativeCall;

# 本当は `is native('libc')` と書きたいのですが、そうすると、うまく動かないのでした。

# basic usage

sub time(CArray[int64] $p)
    returns int64
    is native('/usr/lib64/libc.so.6') { ... }

say time(Mu);

# printf のような可変長引数は 2015.07 現在呼ぶことができない。dyncall は対応しているので、対応するのは不可能ではない。

# sub printf(Str $fmt, CArray[Any])
# returns int64
#   3 is native('/usr/lib64/libc.so.6') { ... }


# it doesn't work.
# printf("hello, %s!\n", "hoge");

sub strchr(Str $s, int8 $c)
    returns Str
    is native('/usr/lib64/libc.so.6') { ... }

say strchr('abcdef', 'd'.ord); # -> def

say strchr('abcdef', 'x'.ord); # (Str)


