require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/asdf"
require "capistrano/scm/git"
require "bundler"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rbenv"
require "capistrano/rails"
require "capistrano/bundler"
# require "capistrano/rails/assets"
require 'capistrano/rails/migrations'
# require "capistrano/passenger"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
