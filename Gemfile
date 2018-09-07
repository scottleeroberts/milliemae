source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'acts-as-taggable-on', '~> 5.0'
gem 'bcrypt'
gem 'bootstrap', '~> 4.0.0'
gem 'browser'
gem 'carrierwave', '~> 1.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'erubis'
gem 'fog-aws'
gem 'friendly_id', '~> 5.1.0'
gem 'jbuilder', '~> 2.5'
gem 'jcrop-rails-v2'
gem 'jquery-rails'
gem 'mini_magick'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'quilljs-rails'
gem 'rails', '~> 5.1.5'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate', '~> 3.1.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'pry-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
