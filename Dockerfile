# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.3

# ------------------------
# base ステージ
# ------------------------
FROM ruby:${RUBY_VERSION}-slim AS base
WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential libyaml-dev libpq-dev libjemalloc2 libvips \
        postgresql-client nodejs npm pkg-config curl git && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH="/rails/vendor/bundle" \
    BUNDLE_FORCE_RUBY_PLATFORM=true \
    PATH="/rails/bin:$PATH"

# bundler 2.5.9 をインストール
RUN gem update --system && gem install bundler -v 2.5.9

# ------------------------
# build ステージ
# ------------------------
FROM base AS build

# rails ユーザー作成
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

WORKDIR /rails

# Gemfile をコピー
COPY Gemfile Gemfile.lock ./

# pg ビルドオプション
RUN bundle config build.pg --with-pg-config=/usr/bin/pg_config

# gems インストール & binstubs作成
RUN bundle install --jobs $(nproc) --binstubs=bin --clean

# アプリケーションコピー
COPY . .

# ファイル所有権を rails ユーザーに変更
RUN chown -R rails:rails /rails

# rails ユーザーで assets precompile
USER rails:rails
RUN bundle exec rails assets:precompile

# ------------------------
# final ステージ
# ------------------------
FROM base
WORKDIR /rails

# build ステージの成果物をコピー
COPY --from=build /rails /rails

# tmp/log ディレクトリ作成 & 権限変更
RUN mkdir -p /rails/tmp/pids /rails/tmp/sockets /rails/log && \
    chown -R 1000:1000 /rails/tmp /rails/log

# rails ユーザーで実行
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
