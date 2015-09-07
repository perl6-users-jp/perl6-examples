use v6;

# コアのクラスにメソッドの追加をすることもできる。

Str.^add_method('length', method ($self:) {
    chars($self)
});

"hoge".length.say
