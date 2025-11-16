source "https://rubygems.org"

# --------------------
# Rails本体と基本機能
# --------------------
gem "rails", "~> 8.0.2"
gem "propshaft"             # Modern asset pipeline
gem "pg", "~> 1.5"          # PostgreSQL
gem "puma", ">= 5.0"        # Webサーバ
gem "importmap-rails"       # ESM import maps
gem "turbo-rails"           # Hotwire Turbo
gem "stimulus-rails"        # Hotwire Stimulus
gem "jbuilder"              # JSON API構築
gem "solid_cache"           # Cache
gem "solid_queue"           # Queue
gem "solid_cable"           # ActionCable
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

# --------------------
# 認証・決済・検索
# --------------------
gem "devise", "~> 4.9"
gem "stripe"
gem "aws-sdk-s3", require: false
gem "ransack"
gem "dartsass-rails"
gem "bootstrap", "~> 5.3.3"

# --------------------
# 開発・テスト用
# --------------------
group :development, :test do
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop", require: false
  gem "rubocop-rails", require: false

  # テスト関連
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "capybara"
  gem "selenium-webdriver"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"

  # デバッグ・コンソール
  gem "dotenv-rails"
  gem "pry-rails"
  gem "pry-byebug"
end

group :development do
  gem "web-console"
end
