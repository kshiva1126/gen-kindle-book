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

WORKDIR /workspace

COPY . /workspace

CMD ["/bin/bash"]