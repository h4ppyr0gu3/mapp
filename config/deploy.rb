lock "~> 3.17.1"

set :application, "mapp"
set :repo_url, "https://github.com/h4ppyr0gu3/mapp"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/mapp"
set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role)) }
set :migration_command, 'db:migrate'
set :conditionally_migrate, true
set :assets_roles, [:web, :app]
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads', "storage"
append :linked_files, 'config/database.yml', 'config/master.key'
# append :linked_files, "config/master.key"

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

set :keep_releases, 3

Rake::Task["deploy:assets:precompile"].clear_actions
Rake::Task["deploy:assets:backup_manifest"].clear_actions
