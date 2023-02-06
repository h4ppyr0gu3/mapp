set :rails_env, 'production'

server "ssh.h4ppyr0gu3.one", user: "david", roles: %w{app db web}

namespace :deploy do
  after :"deploy:cleanup", :restart_service do
    on roles(:app) do 
      ask(:sudo_password)
      execute("echo #{fetch(:sudo_password)} | sudo -S systemctl restart mapp")
      execute("echo #{fetch(:sudo_password)} | sudo -S systemctl restart mapp_sidekiq")
      # execute("echo #{:sudo_pass} | sudo systemctl restart mapp_sidekiq")
      # execute("sudo systemctl restart mapp_sidekiq")
    end
  end
end
