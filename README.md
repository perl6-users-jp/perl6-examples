# perl6-users-jp/examples
Perl6を用いたコード例の日本語コメント付きのものです。

## FAQ

### Perl6 の仕様はどこ？

[Perl6 Design Documents](https://github.com/perl6/specs/)　が仕様になっています。

### 入門ドキュメントとかあるの？

[Using Perl6(日本語版)](https://dl.dropboxusercontent.com/u/877032/UsingPerl6_JA.html) を読んでみるとよいかもしれません。

## Perl6 の実装はどこ？

[rakudo](https://github.com/rakudo/rakudo) が Perl6 の実装です。Rakudo は MoarVM/JVM を対象として実装されている Perl6 の処理系で、nqp および Perl6 で実装されています。

## nqp ってなに？

[nqp](https://github.com/perl6/nqp/) は not-quite-perl(6) の略で、Perl6 のサブセットです。Perl6 の実装のためにつくられた処理系です。
Perl6 に依存して実装されているわけではなく、汎用のプログラミング言語作成ツールキットになっています。

## Perl6 のテストスイートはどこ？

[roast](https://github.com/perl6/roast/) が test suite です。
テストコードは、サンプルコードとして参考になります。

一部、通ってないテストもあることに注意してください。

## Perl6 の起動って遅いの？

2015.07.02 バージョンでは、すでに起動速度の最適化が行われており、十分に高速です。以下は Core i7 3.5GHz のマシンでの起動速度です。

```
time perl6-m -e '0'
perl6-m -e '0'  0.08s user 0.02s system 97% cpu 0.098 total
```

## Perl6 が出たら　Perl5 は廃れてしまうの？
既存のコードベースが大量にありますので、そんなことにはならないでしょう。
Perl6 がリリースされても Perl5 のメンテナンスは継続されます。

## MoarVM ってなに？

[MoarVM](https://github.com/MoarVM/MoarVM) とは、Perl6 をターゲットに開発された VM です。JIT なども積んでおり、高速に安定して動作します。

## Parrot ってどうなったの？
Parrot はもはや Rakudo のメインターゲットではありません。MoarVM をご利用ください。

## Perl6 のバグを発見したのだけど？

https://rt.perl.org/Public/ ←　が  BTS です。

## export された method の実態を取りたいのですが

Perl5 で言うところの `__PACKAGE__->can("done_testing")` は `&::('done_testing')` で実現できます。

## REPL が使いづらいのですが

    panda install Linenoise

するとまともになります｡

## CPAN みたいなものはありますか?

panda というのがそれです｡

## 起動が遅いのですが?

Moar の場合、--stagestats オプションでどのステージで時間がかかっているか確認することができます。

    $ perl6-m --stagestats -Ilib bin/crustup
    Stage start      :   0.000
    Stage parse      :   8.409
    Stage syntaxcheck:   0.000
    Stage ast        :   0.000
    Stage optimize   :   0.003
    Stage mast       :   0.019
    Stage mbc        :   0.001
    Stage moar       :   0.000
    Usage:
      bin/crustup [--port=<Int>] [--shotgun] [--workers=<Int>] <appfile> [<host>]

## perl6-jvm の起動遅すぎませんか?

eval-server ついてるのでご利用ください。

    ./install/bin/perl6-eval-server -cookie TESTTOKEN -app ./perl6.jar

でサーバー起動。

    ./install/bin/eval-client.pl TESTTOKEN 'run' '-e' 'say 4'

でクライアント走ります。

## それにしても起動が遅すぎませんか?

perl6 のライブラリをインストールするときに､最近の panda だと precompile が行われなくなっています｡
precompile とはつまり､.pm ファイルを .moarvm ファイルにコンパイルしておく処理のことです｡

Perl6 は開発途中のため､このあたりがまだ手薄です｡

https://github.com/perl6-users-jp/perl6-examples/blob/master/bin/perl6-precompile-all を実行するととりあえず全部 precompile するので､速くなります｡

## Minilla みたいなのないんすか?

https://github.com/shoichikaji/mi6 があります。モジュール作るときはこれ使うのがおすすめです。

## `Class::Load::load_class($klass)` みたいなのどうやって実装したらいいんですか?

    require ::($module_name);
    ::($module_name).new;

## rakudo ビルドが途中で止まるのですが

    Stage mbc        : Killed

などと出ていませんか?

現状の rakudo のビルドは 800MB ほどのメモリを必要とするため OOM が走ってしまうことがあります。

OOM が走る場合にはメモリを増やしてください。

## B::Deparse や B::Terse のようなものはありますか?

    perl6 --target=ast -e 'my @a = $_.split(/\s/)'

のようにすると､良い感じに動くようになります｡

## Rakudo とか Moar がバグってるっぽいからデバッグしたいんですけどどうすれば良いですか

環境変数 `RAKUDO_MODULE_DEBUG=1` を設定して実行してみましょう．
perl6 の実行オプションに `--stagestats` や `--ll-exceptions` を付与して実行してみるのも手です．

また `strace` を使ってシステムコールを見るというのも選択肢の一つとなるでしょう．

## Rakudo のデバッグ・開発をしたいのですが？

```
cd /path/to/MoarVM && perl Configure.pl --prefix=/tmp/perl6/ --make-install
cd /path/to/nqp && perl Configure.pl --prefix=/tmp/perl6/ --backends=moar --make-install
cd /path/to/rakudo && perl Configure.pl --prefix=/tmp/perl6/ --backends=moar --make-install
```

などとして，rakudo をビルドしつつ開発をすることが可能です．
