# サンプル電子書籍

## 目次

1. はじめに
2. 基本的な使い方
3. 応用編

---

# 第1章 はじめに

この章では、本書の概要と目的について説明します。

## 1.1 本書の目的

本書は、Markdownで書かれたコンテンツをEpub形式に変換し、最終的にKindleで読めるようにすることを目的としています。

## 1.2 想定読者

以下のような方を想定しています：

- Markdownで文章を書きたい方
- 電子書籍を作成したい方
- Kindleで自作コンテンツを読みたい方

## 1.3 本書の構成

本書は以下の構成になっています：

1. **第1章 はじめに** - 本書の概要
2. **第2章 基本的な使い方** - 基本操作の説明
3. **第3章 応用編** - 高度な機能の紹介

---

# 第2章 基本的な使い方

この章では、基本的な使い方について説明します。

## 2.1 インストール

まず必要なツールをインストールします。

### 2.1.1 Dockerのインストール

Dockerが必要です。公式サイトからインストールしてください。

### 2.1.2 プロジェクトのセットアップ

```bash
git clone https://github.com/yourusername/gen-kindle-book.git
cd gen-kindle-book
```

## 2.2 基本的な変換

以下のコマンドで変換を実行します：

```bash
./convert.sh books/sample
```

## 2.3 出力結果

変換されたEpubファイルは`output`ディレクトリに保存されます。

---

# 第3章 応用編

この章では、より高度な機能について説明します。

## 3.1 カスタマイズ

### 3.1.1 スタイルシートの適用

独自のCSSを適用して見た目をカスタマイズできます。

```css
body {
    font-family: "Noto Sans JP", sans-serif;
    line-height: 1.8;
}

h1 {
    color: #333;
    border-bottom: 2px solid #007acc;
}
```

### 3.1.2 メタデータの設定

書籍情報を詳細に設定できます。

## 3.2 画像の挿入

Markdownの標準的な記法で画像を挿入できます：

```markdown
![代替テキスト](images/sample.png)
```

## 3.3 まとめ

本章では応用的な使い方について説明しました。これらの機能を活用することで、より高品質な電子書籍を作成できます。