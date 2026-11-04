source "https://rubygems.org"

ruby "4.0.6"
gem "rails", "8.1.4"
gem "puma", ">= 6.0"

# Keep this starter's existing asset pipeline and import maps.
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Explicit dependencies for Ruby 4; IRB powers bin/rails console.
gem "json"
gem "irb"
gem "fiddle", platforms: :windows

group :development, :test do
  gem "sqlite3", ">= 2.1"
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Render uses PostgreSQL; local development and tests use SQLite.
group :production do
  gem "pg", "~> 1.5"
end
