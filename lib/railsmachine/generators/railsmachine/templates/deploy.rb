require 'railsmachine/recipes'

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

# The name of your application. Used for directory and file names associated with
# the application.
set :application, "<%= singular_name %>"

# Target directory for the application on the web and app servers.
set :deploy_to, "/var/www/apps/#{application}"

# Primary domain name of your application. Used as a default for all server roles.
set :domain, "<%= domain_name %>"

# Login user for ssh.
set :user, "deploy"

# Rails environment. Used by application setup tasks and migrate tasks.
set :rails_env, "production"

# Automatically symlink these directories from curent/public to shared/public.
# set :app_symlinks, %w{photo document asset}

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

# Modify these values to execute tasks on a different server.
role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :scm, domain

# =============================================================================
# WEB SERVER OPTIONS
# =============================================================================
# set :httpd, "apache"   # apache or nginx
# set :httpd_server_name, domain
# set :httpd_server_aliases, %w{alias1 alias2}
# set :httpd_default_vhost, true # force use of httpd_default_vhost_config
# set :httpd_default_vhost_conf, "/etc/httpd/conf/default.conf"
# set :httpd_conf, "/etc/httpd/conf/apps/#{application}.conf"
# set :httpd_proxy_port, 8000
# set :httpd_proxy_servers, 2
# set :httpd_proxy_address, "127.0.0.1"
# set :httpd_ssl_enabled, false
# set :httpd_ssl_ip, "127.0.0.1"
# set :httpd_ssl_forward_all, false
# set :httpd_ctl, "/etc/init.d/httpd"

# =============================================================================
# MONGREL OPTIONS
# =============================================================================
# set :mongrel_servers, httpd_proxy_servers
# set :mongrel_port, httpd_proxy_port
# set :mongrel_address, httpd_proxy_address
# set :mongrel_environment, "production"
# set :mongrel_pid_file, "/var/run/mongrel_cluster/#{application}.pid"
# set :mongrel_conf, "/etc/mongrel_cluster/#{application}.conf"
# set :mongrel_user, user
# set :mongrel_group, group

# =============================================================================
# DATABASE OPTIONS
# =============================================================================
# set :database, "mysql"   # mysql or postgresql

# =============================================================================
# SCM OPTIONS
# =============================================================================
# set :scm, :subversion
set :repository do
  if scm == :subversion
    "svn+ssh://#{user}@#{domain}#{deploy_to}/repos/trunk"
  elsif scm == :git
    "ssh://#{user}@#{domain}#{deploy_to}/repos"
  end
end

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
# default_run_options[:pty] = true
# set :keep_releases, 3