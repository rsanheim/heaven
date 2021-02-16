ruby "2.7.2"
source "https://rubygems.org"

gem "rails", "~> 5.1"
gem "resque"
gem "resque-lock-timeout"
gem "octokit"
gem "unicorn"
gem "yajl-ruby"
gem "posix-spawn"
gem "warden-github-rails"
gem "faraday"
gem "faraday_middleware"

# Providers
gem "dpl"
gem "aws-sdk"
gem "aws-sdk-lambda", "~> 1"
gem "capistrano", "~> 3.4.0"

# Notifiers
gem "hipchat"
gem "campfiyah"
gem "slack-notifier"
gem "flowdock"

group :test do
  gem "sqlite3"
  gem "webmock"
  gem "simplecov"
  gem "rubocop"
  gem "rspec-rails"
  gem "vcr"
end

group :development do 
  gem "guard-rspec"
  gem "foreman"
  gem "meta_request"
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem "byebug"
  gem "pry-rails"
end

group :staging, :production do
  gem "pg"
end
