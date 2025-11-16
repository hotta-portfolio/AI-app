# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.3

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# base ステージ
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails
# Debug: WORKDIR /rails の後
RUN echo "DEBUG: (base stage) After WORKDIR /rails, current directory: $(pwd)" > /tmp/docker_debug.log 2>&1

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libyaml-dev \
    libpq-dev \
    libjemalloc2 \
    libvips \
    postgresql-client \
    nodejs \
    npm  \
    pkg-config \
    curl \
    git && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
ENV BUNDLE_PATH="/rails/vendor/bundle" \
    BUNDLE_FORCE_RUBY_PLATFORM=true \
    PATH="/rails/bin:$PATH"
RUN gem update --system && gem install bundler

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# build ステージ
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
FROM base AS build

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Debug: build ステージに入った直後 (WORKDIRはbaseから引き継がれる)
RUN echo "DEBUG: (build stage) Start, current directory: $(pwd)" >> /tmp/docker_debug.log 2>&1

COPY Gemfile Gemfile.lock ./

# =================================================================
# 【💥 修正点】pg gem のビルド設定を強制的に上書き
# Render環境で pg_config のパスを明示し、Homebrewパス参照を防ぐ
# =================================================================
RUN bundle config build.pg --with-pg-config=/usr/bin/pg_config && \
    echo "DEBUG: Bundler config for pg set to /usr/bin/pg_config" >> /tmp/docker_debug.log 2>&1

RUN bundle install --jobs $(nproc) --no-prune --clean && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    chown -R 1000:1000 "${BUNDLE_PATH}"

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# 最終イメージ
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
FROM base
# Debug: 最終イメージステージに入った直後 (WORKDIRはbaseから引き継がれる)
RUN echo "DEBUG: (final stage) Start, current directory: $(pwd)" >> /tmp/docker_debug.log 2>&1

COPY --from=build /rails /rails
RUN echo "DEBUG: (final stage) After COPY --from=build, current directory: $(pwd)" >> /tmp/docker_debug.log 2>&1 && \
    echo "DEBUG: (final stage) Content of /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ after build copy:" >> /tmp/docker_debug.log 2>&1 && \
    ls -l /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ >> /tmp/docker_debug.log 2>&1

COPY . .

RUN echo "DEBUG: (final stage) After COPY ., current directory: $(pwd)" >> /tmp/docker_debug.log 2>&1 && \
    echo "DEBUG: (final stage) Content of /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ after app copy:" >> /tmp/docker_debug.log 2>&1 && \
    ls -l /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ >> /tmp/docker_debug.log 2>&1

# RUN bundle check

# Debug: bundle check の後
RUN echo "DEBUG: (final stage) After bundle check, current directory: $(pwd)" >> /tmp/docker_debug.log 2>&1 && \
    echo "DEBUG: (final stage) Content of /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ after final bundle check:" >> /tmp/docker_debug.log 2>&1 && \
    ls -l /rails/vendor/bundle/ruby/${RUBY_VERSION%.*}.0/gems/ >> /tmp/docker_debug.log 2>&1

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp public/assets/builds node_modules && \
    chown -R 1000:1000 /rails /usr/local/bundle

USER 1000:1000
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
