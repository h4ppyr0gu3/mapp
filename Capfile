# frozen_string_literal: true

require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/asdf"
require "capistrano/scm/git"
require "bundler"
install_plugin Capistrano::SCM::Git
require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/rails/migrations"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
