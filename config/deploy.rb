# config valid only for current version of Capistrano
lock '3.8.1'

set :application, 'moi'
set :repo_url, 'git@github.com:GrowMoi/moi.git'

set :slack_webhook, 'https://hooks.slack.com/services/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'
set :slack_username, 'capistrán'
set :slack_icon_url, 'https://fbcdn-photos-c-a.akamaihd.net/hphotos-ak-xtf1/v/t1.0-0/p206x206/12006242_10206396576286104_673800911875941646_n.jpg?oh=8b32b58bc12834ce054f8f71c194c4cd&oe=56DD7C36&__gda__=1456750887_deeec940f63edd5cc2130f953b103097'

# delayed_job
set :delayed_job_prefix, :moi_backend

set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/growmoi/moi'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :rbenv_ruby, '2.1.4'

set :passenger_restart_with_touch, true

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
