# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.3

# =========================
# base ステージ
# =========================
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

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

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

COPY Gemfile Gemfile.lock ./

RUN bundle config build.pg --with-pg-config=/usr/bin/pg_config

RUN bundle install --jobs $(nproc) --no-prune --clean && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    chown -R 1000:1000 "${BUNDLE_PATH}"

COPY . .
RUN bundle exec rails assets:precompile

FROM base

WORKDIR /rails

COPY --from=build /rails /rails

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
