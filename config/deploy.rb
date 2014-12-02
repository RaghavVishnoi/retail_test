# config valid only for current version of Capistrano
lock '3.3.3'

set :application, 'fosem-staging'
set :repo_url, 'git@github.com:LetsgomoLabs/feet-on-street-enterprise-mobility-solutions-backend.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :deploy do
  task :install do
    on roles(:all) do
      execute "sudo apt-get update"
      execute "sudo apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties"
    end
  end

  # task :install_ruby do
  #   on roles(:all) do
  #     execute "wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz"
  #     execute "tar -xzvf ruby-2.1.2.tar.gz"
  #     execute %Q{cd ruby-2.1.2/; ./configure; make; sudo make install;}
  #     execute %Q{echo "gem: --no-ri --no-rdoc" > ~/.gemrc}
  #   end
  # end
end

namespace :app do
  task :update_rvm_key do
    on roles(:all) do
      execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
    end
  end
end

before "rvm1:install:rvm", "app:update_rvm_key"
after 'deploy:install', 'rvm1:install:rvm'
after 'deploy:install', 'rvm1:install:ruby'  # install/update Ruby

namespace :mysql do
  task :install do
    on roles(:db) do
      execute %Q{sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'}
      execute %Q{sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'}
      execute "export DEBIAN_FRONTEND=noninteractive; sudo apt-get -y install mysql-server mysql-client libmysqlclient-dev"
    end
  end
end

after 'deploy:install', 'mysql:install'

namespace :passenger_nginx do
  task :setup_apt_sources do
    on roles(:web) do
      execute %Q{sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7}
      execute %Q{sudo add-apt-repository -y https://oss-binaries.phusionpassenger.com/apt/passenger}
    end
  end

  task :install do
    on roles(:web) do
      execute "sudo apt-get update"
      execute "sudo apt-get install -y nginx-extras passenger"
    end
  end

  task :configure do
    on roles(:web) do
      template = File.read(File.join(File.dirname(__FILE__), "deploy/nginx/nginx.conf.erb"))
      result = ERB.new(template).result(binding)
      upload! StringIO.new(result), "/tmp/nginx.conf"
      execute "sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf"
    end
  end
end

before 'passenger_nginx:install', 'passenger_nginx:setup_apt_sources'
after 'deploy:install', 'passenger_nginx:install'