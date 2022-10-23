# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "down"
gem "jsbundling-rails"
gem "kaminari"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "pundit", "~> 2.2"
gem "rack-cors"
gem "rails", "~> 7.0.2", ">= 7.0.2.4"
gem "ransack"
gem "redis", "~> 4.0"
gem "rubyzip"
gem "sass-rails"
gem "sidekiq"
gem "sitemap_generator"
gem "slim"
gem "sprockets-rails"
gem "tzinfo-data"
gem "uglifier"
gem "zipline"

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
  gem "rubocop"
  gem "web-console"
end

gem "prometheus_exporter", "~> 2.0"
