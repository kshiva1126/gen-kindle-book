# gen-kindle-book

MarkdownファイルからEPUBとPDFを生成し、Kindleで読める電子書籍を作成するツールです。

## 機能

- MarkdownからEPUB形式への変換
- MarkdownからPDF形式への変換  
- 日本語フォント完全対応
- メタデータ管理
- 書籍別の出力ディレクトリ管理

## 必要な環境

- Docker
- bash

## プロジェクト構造

```
gen-kindle-book/
├── Dockerfile              # pandoc + 日本語フォント環境
├── convert.sh              # 変換スクリプト
├── README.md               # このファイル
├── books/                  # 書籍データディレクトリ
│   ├── sample/             # サンプル書籍
│   │   ├── book.md         # 書籍本文
│   │   ├── metadata.yml    # メタデータ
│   │   └── template.tex    # LaTeXテンプレート（オプション）
│   └── 新しい書籍名/
│       ├── book.md         # 必須：書籍本文
│       ├── metadata.yml    # 推奨：メタデータ
│       └── cover.jpg       # オプション：カバー画像
└── output/                 # 出力ディレクトリ
    └── 書籍名/
        ├── 書籍名.epub
        └── 書籍名.pdf
```

## セットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd gen-kindle-book
```

### 2. Dockerイメージのビルド

```bash
docker build -t gen-kindle-book .
```

## 新しい書籍の作成

### 1. 書籍ディレクトリの作成

```bash
mkdir -p "books/あなたの書籍名"
```

### 2. 必須ファイルの作成

#### book.md（必須）

書籍の本文をMarkdown形式で作成します。

```markdown
# あなたの書籍タイトル

## 第1章 はじめに

ここに本文を書きます...

## 第2章 基本的な使い方

章ごとに内容を整理して書きます...

---

## 第3章 応用編

より詳細な内容を...
```

#### metadata.yml（推奨）

書籍のメタデータを設定します。

```yaml
---
title: "あなたの書籍タイトル"
author: "著者名"
date: "2025-06-22"
language: "ja"
publisher: "出版社名"
rights: "© 2025 著者名"
description: "書籍の説明文"
subject: "ジャンル"
identifier:
  - scheme: "ISBN"
    text: "978-4-00000-000-0"
creator:
  - role: "author"
    text: "著者名"
---
```

#### cover.jpg（オプション）

カバー画像を追加する場合は、`cover.jpg`という名前でファイルを配置し、metadata.ymlに以下を追加：

```yaml
cover-image: "cover.jpg"
```

## 変換の実行

### 基本的な使用方法

```bash
# EPUB生成（デフォルト）
./convert.sh books/あなたの書籍名

# PDF生成
./convert.sh --pdf books/あなたの書籍名

# EPUB・PDF両方生成
./convert.sh --both books/あなたの書籍名
```

### オプション

- `--epub`: EPUB形式で生成（デフォルト）
- `--pdf`: PDF形式で生成
- `--both`: EPUB・PDF両方を生成

## 出力ファイル

変換後のファイルは `output/書籍名/` ディレクトリに保存されます：

```
output/
└── あなたの書籍名/
    ├── あなたの書籍名.epub
    └── あなたの書籍名.pdf
```

## Markdownの記法

### 基本的な記法

```markdown
# 第1章（H1 - 章タイトル）
## 1.1 節タイトル（H2）
### 1.1.1 小節タイトル（H3）

**太字**
*斜体*

- 箇条書き
- 項目2

1. 番号付きリスト
2. 項目2

> 引用文

`インラインコード`

\```
コードブロック
\```

[リンクテキスト](https://example.com)

![画像の説明](images/sample.png)
```

### 日本語での注意点

- 見出しは自動的に目次に反映されます
- PDF生成時は日本語フォント（Noto Sans CJK JP）が適用されます
- 章の区切りは `---` で行えます

## カスタマイズ

### LaTeXテンプレートのカスタマイズ

PDF出力のレイアウトをカスタマイズしたい場合は、書籍ディレクトリに `template.tex` ファイルを配置してください。サンプルは `books/sample/template.tex` を参考にしてください。

### CSSスタイルのカスタマイズ

EPUB出力のスタイルをカスタマイズしたい場合は、書籍ディレクトリに `style.css` ファイルを配置してください。

## トラブルシューティング

### よくある問題

1. **"book.md not found" エラー**
   - 書籍ディレクトリに `book.md` ファイルがあることを確認してください

2. **日本語が正しく表示されない**
   - Dockerイメージが正しくビルドされていることを確認してください
   - `docker build -t gen-kindle-book .` を再実行してください

3. **PDFの生成に時間がかかる**
   - 大きなファイルの場合、数分かかることがあります
   - 初回実行時はLaTeXパッケージのダウンロードが発生するため時間がかかります

### ログの確認

変換中にエラーが発生した場合は、コンソールに表示されるエラーメッセージを確認してください。


## ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 貢献

バグ報告や機能提案は、GitHubのIssueでお願いします。

---

**注意**: 初回実行時はDockerイメージのビルドに時間がかかる場合があります。