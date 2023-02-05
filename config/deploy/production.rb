set :rails_env, 'production'

server "ssh.h4ppyr0gu3.one", user: "david", roles: %w{app db web}

namespace :deploy do
  before :starting, :ensure_user do
    #
  end

  after :finishing, :notify do
    #
  end
end
