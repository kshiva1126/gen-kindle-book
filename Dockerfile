FROM pandoc/latex:latest

# 日本語フォントと必要なパッケージをインストール
RUN apk add --no-cache \
    bash \
    python3 \
    py3-pip \
    make \
    fontconfig \
    font-noto-cjk \
    font-noto-emoji

# XeLaTeX用の日本語パッケージをインストール
RUN tlmgr install xecjk fontspec

# Eisvogelテンプレートに必要なLaTeXパッケージをインストール
RUN tlmgr install \
    adjustbox \
    babel-german \
    background \
    bidi \
    collectbox \
    csquotes \
    everypage \
    filehook \
    footmisc \
    footnotebackref \
    framed \
    fvextra \
    letltxmacro \
    ly1 \
    mdframed \
    mweights \
    needspace \
    pagecolor \
    sourcecodepro \
    sourcesanspro \
    titling \
    ucharcat \
    unicode-math \
    upquote \
    xurl \
    zref \
    draftwatermark \
    awesomebox \
    tcolorbox \
    listings \
    koma-script

WORKDIR /workspace

COPY . /workspace

CMD ["/bin/bash"]