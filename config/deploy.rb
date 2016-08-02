# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'none_of_the_above'
set :repo_url, 'git@github.com:ted-collins/none_of_the_above.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/none_of_the_above'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'config/environments', 'config/initializers', 'public/assets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after "deploy", "deploy:cleanup"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute "find #{release_path.join('tmp')} -type f -exec /bin/chmod 0666 {} +"
      execute "find #{release_path.join('tmp')} -type d -exec /bin/chmod 0777 {} +"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  desc "Restart web server"
  after :restart, :clear_cache do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /usr/sbin/apache2ctl restart"
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Create correct bin links"
  task :bin do
    on roles(:app), in: :sequence, wait: 5 do
      #execute "echo \"cd '#{release_path}'; rake rails:update:bin\" | sudo su - www-data"
    end
  end

  desc "Migrate, Bundle, Assets"
  task :compile_assets do
    on roles(:app), in: :sequence, wait: 5 do
      execute "echo \"cd '#{release_path}'; RAILS_ENV=production rake db:migrate\" | sudo su - www-data"
      execute "echo \"cd '#{release_path}'; RAILS_ENV=production bundle install\" | sudo su - www-data"
      execute "echo \"cd '#{release_path}'; RAILS_ENV=production rake assets:precompile\" | sudo su - www-data"
	end
  end

  desc "Fix Permissions"
  task :fix_permissions do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd '#{release_path}'; sudo chgrp www-data Gemfile.lock"
	end
  end

  before :compile_assets, :fix_permissions
  before :restart, :compile_assets
  before :restart, :bin

end
