# 古い buster はやめて、現行の Debian 12(bookworm)の slim 版へ
FROM python:3.9-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8 \
    TERM=xterm

# 必要パッケージを一括で入れてからキャッシュ削除（イメージを太らせない）
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      locales \
      vim-tiny \
      less \
      git  \
 # 日本語ロケールを生成（slimはlocale未生成なのでここが重要）
 && sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=ja_JP.UTF-8 \
 # aptキャッシュを捨ててスリム化
 && rm -rf /var/lib/apt/lists/*

# pip は最新版・setuptoolsも併せてアップグレード
RUN pip install --no-cache-dir --upgrade pip setuptools \
 && pip install --no-cache-dir dbt-core dbt-bigquery
