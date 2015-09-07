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

