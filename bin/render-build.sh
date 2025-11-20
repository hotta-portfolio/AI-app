#!/bin/bash
set -e  # 途中で失敗したら停止

bundle install
yarn install
rails assets:precompile RAILS_ENV=production
rails db:migrate RAILS_ENV=production
