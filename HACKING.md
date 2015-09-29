# Perl6 HACKING GUIDE

Perl6 に興味ある人のためのハッキングガイドです｡

## google perftools でパフォーマンスを調べるのはどうですか?

`LD_PRELOAD` を利用した場合､以下のようになり､測定ができませんでした｡-lprofileならまた違うのかもしれませんけど｡

    $ CPUPROFILE=prof.out LD_PRELOAD=/usr/lib64/libprofiler.so /home/tokuhirom/.rakudobrew/bin/../moar-nom/install/bin/perl6-m -Ilib t/01-request-parser.t
    Unhandled exception: Malformed UTF-8 at line 1 col 12
    at gen/moar/stage2/QRegex.nqp:198  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/QRegex.moarvm::117)
    from gen/moar/stage2/QRegex.nqp:11  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/QRegex.moarvm:<mainline>:44)
    from <unknown>:1  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/QRegex.moarvm:<load>:6)
    from src/vm/moar/ModuleLoader.nqp:51  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/ModuleLoader.moarvm::87)
    from src/vm/moar/ModuleLoader.nqp:41  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/ModuleLoader.moarvm:load_module:83)
    from <unknown>:1  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/NQPP6QRegex.moarvm:<dependencies+deserialize>:28)
    from src/vm/moar/ModuleLoader.nqp:51  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/ModuleLoader.moarvm::87)
    from src/vm/moar/ModuleLoader.nqp:41  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/nqp/lib/ModuleLoader.moarvm:load_module:83)
    from <unknown>:1  (/home/tokuhirom/.rakudobrew/moar-nom/install/share/perl6/runtime/perl6.moarvm:<dependencies+deserialize>:28)
    PROFILE: interrupts/evictions/bytes = 0/0/64
