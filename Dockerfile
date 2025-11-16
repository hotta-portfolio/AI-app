# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.3

# =========================
# base ステージ
# =========================
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# 必須パッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        libyaml-dev \
        libpq-dev \
        libjemalloc2 \
        libvips \
        postgresql-client \
        nodejs \
        npm \
        pkg-config \
        curl \
        git && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH="/rails/vendor/bundle" \
    BUNDLE_FORCE_RUBY_PLATFORM=true \
    PATH="/rails/bin:$PATH"

RUN gem update --system && gem install bundler

# =========================
# build ステージ
# =========================
FROM base AS build

# Rails 用ユーザー作成
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Gemfile をコピー
COPY Gemfile Gemfile.lock ./

# pg gem ビルド設定を明示
RUN bundle config build.pg --with-pg-config=/usr/bin/pg_config

# bundle install
RUN bundle install --jobs $(nproc) --no-prune --clean && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    chown -R 1000:1000 "${BUNDLE_PATH}"

# =========================
# 最終イメージ
# =========================
FROM base

WORKDIR /rails

# build ステージの Rails ディレクトリをコピー
COPY --from=build /rails /rails

# アプリ本体をコピー
COPY . .

# Rails 用ユーザー作成 & 必須ディレクトリ作成
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp public/assets/builds node_modules && \
    chown -R 1000:1000 /rails /usr/local/bundle

USER 1000:1000

# Entrypoint と CMD
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
