# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "devise_token_auth", "~> 1.2"
gem "down"
gem "jsbundling-rails"
gem "kaminari"
gem "omniauth", "~> 2.1"
gem "pg", "~> 1.1"
gem "prometheus_exporter", "~> 2.0"
gem "puma", "~> 5.0"
gem "pundit", "~> 2.2"
gem "rack-cors"
gem "rails", "~> 7.0.2", ">= 7.0.2.4"
gem "ransack"
gem "redis", "~> 4.0"
gem "rubyzip"
gem "sass-rails"
gem "sidekiq"
gem "sidekiq-cron", "~> 1.8"
gem "sitemap_generator"
gem "slim"
gem "sprockets-rails"
gem "tzinfo-data"
gem "uglifier"
gem "zipline"
gem "dry-validation", "~> 1.8"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "pry"
  gem "rspec-rails"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "shoulda-matchers"
end

group :development do
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-asdf"
  gem "capistrano-bundler"
  gem "capistrano-rails", require: false
  gem "letter_opener_web", "~> 2.0"
  gem "rubocop"
  gem "web-console"
end

gem "logster"
