# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages and development tools
# For development, we might need Node.js for JavaScript bundling, etc.
# Also, add any other development-specific system dependencies here.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 postgresql-client git nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment
# BUNDLE_WITHOUT is removed to install development gems
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/bundle"

    # BUNDLE_DEPLOYMENT is not set for development

# Throw-away build stage to reduce size of final image (still useful for caching gem installation)
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libyaml-dev pkg-config libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems (including development gems)
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
    # Bootsnap precompile is more for production, can be skipped or kept based on preference for dev startup
    # RUN bundle exec bootsnap precompile --gemfile

# Copy application code (This will be overlaid by docker-compose volume mount in development)
COPY . .

# Bootsnap precompile for app/ and lib/ can be skipped for development to avoid stale cache issues with volume mounts
# RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets is NOT needed for development mode
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image (for development, this can be simpler)
FROM base

# Copy built gems
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"

# Copy application code again (or rely on volume mount from docker-compose)
# If using docker-compose with volumes, this COPY might be less critical for development,
# but good for consistency if the image is run standalone.
COPY --from=build /rails /rails

# Ensure Node.js and npm are available for JS bundling if not already in base or if base was minimal
# RUN apt-get update -qq && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

# Run and own only the runtime files as a non-root user for security (good practice even in dev)
# We might run as root initially for `bundle install` or `yarn install` if needed,
# then switch to a non-root user.
# For simplicity in development, sometimes the user setup is deferred or handled by docker-compose.
# However, keeping it is generally safer.
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    # Ensure the app directory is owned by the rails user if files are copied
    # chown -R rails:rails /rails
    # For development with volume mounts, permissions on mounted volumes can be tricky.
    # Often, the container runs with the same UID/GID as the host user for mounted volumes.
    # Or, ensure directories like tmp, log, storage are writable by the user.
    mkdir -p db log storage tmp public/assets/builds node_modules && \
    chown -R rails:rails db log storage tmp public/assets/builds node_modules

USER 1000:1000

# Entrypoint prepares the database (can be kept or handled by docker-compose command)
# For development, you might not always need a fixed entrypoint if docker-compose overrides the command.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Default command. For development, this will likely be overridden by docker-compose
# to use `bin/dev` if you are using jsbundling-rails with a Procfile.dev.
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
