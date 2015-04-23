# config valid only for current version of Capistrano
lock '3.3.3'

set :application, 'fosem-staging'
set :repo_url, 'git@github.com:LetsgomoLabs/gionee_be.git'

set :tmp_dir, "/home/fosem/tmp"

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
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'analytics')

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
      write_template("deploy/nginx/nginx.conf.erb", "/opt/nginx/conf/nginx.conf", "nginx.conf")
    end
  end

  task :start do
    on roles(:web) do
      execute "sudo /etc/init.d/nginx start"
    end
  end

  task :stop do
    on roles(:web) do
      execute "sudo /etc/init.d/nginx stop"
    end
  end

  task :restart do
    on roles(:web) do
      execute "sudo /etc/init.d/nginx restart"
    end
  end
end

namespace :logrotate do
  task :configure do
    on roles(:web) do
      write_template("deploy/logrotate/log.conf", "/etc/logrotate.d/fosem", 'logrotate')
    end
  end
end


namespace :monit do
  task :configure do
    on roles(:web) do
      write_template("deploy/monit/monit.conf.erb", "/etc/monit.conf", "monit.conf")
    end
  end

  task :restart do
    on roles(:web) do
      execute "sudo service monit restart"
    end
  end

  task :stop do
    on roles(:web) do
      execute "sudo service monit stop"
    end
  end
end

# before "monit:restart", "monit:configure"

before 'passenger_nginx:install', 'passenger_nginx:setup_apt_sources'
after 'deploy:install', 'passenger_nginx:install'

before "passenger_nginx:restart", "passenger_nginx:configure"
before "passenger_nginx:start", "passenger_nginx:configure"

after "deploy:publishing", "deploy:restart"
after "deploy:published", "logrotate:configure"

# after "deploy:start", "passenger_nginx:start"
# after "deploy:stop", "passenger_nginx:stop"
after "deploy:restart", "passenger_nginx:restart"
after "deploy:restart", "delayed_job:restart"
# after "deploy:restart", "monit:restart"
before "deploy:restart", "monit:stop"
after "passenger_nginx:restart", "monit:restart"

def write_template(erb_template, target, tmp)
  template = File.read(File.join(File.dirname(__FILE__), erb_template))
  result = ERB.new(template).result(binding)
  tmp_path = "/tmp/#{tmp}"
  upload! StringIO.new(result), tmp_path
  execute "sudo mv #{tmp_path} #{target}"
end