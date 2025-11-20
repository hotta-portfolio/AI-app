#!/usr/bin/env bash
set -e

echo "=== Installing Ruby gems ==="
bundle install --jobs 4 --retry 3

echo "=== Installing JS dependencies ==="
yarn install --check-files

echo "=== Running DB migrations ==="
bundle exec rails db:migrate RAILS_ENV=production

echo "=== Seeding initial data ==="
bundle exec rails db:seed RAILS_ENV=production

echo "=== Precompiling assets ==="
bundle exec rails assets:precompile

echo "=== Build finished ==="
