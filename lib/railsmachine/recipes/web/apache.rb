require 'erb'
Capistrano::Configuration.instance(:must_exist).load do
  
  set :apache_server_name, nil
  set :apache_conf, nil
  set :apache_default_vhost, false
  set :apache_default_vhost_conf, nil
  set :apache_ctl, "/etc/init.d/httpd"
  set :apache_server_aliases, []
  set :apache_proxy_port, 8000
  set :apache_proxy_servers, 2
  set :apache_proxy_address, "127.0.0.1"
  set :apache_ssl_enabled, false
  set :apache_ssl_ip, nil
  set :apache_ssl_forward_all, false
  
  namespace :apache do
  
    desc "Configure Apache. This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true."
    task :configure, :roles => :web do
      set_apache_conf
      
      server_aliases = []
      server_aliases << "www.#{apache_server_name}"
      server_aliases.concat apache_server_aliases
      set :apache_server_aliases_array, server_aliases
      
      file = File.join(File.dirname(__FILE__), "templates", fetch(:app_server), "httpd.conf")
      template = File.read(file)
      buffer = ERB.new(template).result(binding)
      
      if apache_ssl_enabled
        file = File.join(File.dirname(__FILE__), "templates", fetch(:app_server), "httpd-ssl.conf")
        template = File.read(file)
        ssl_buffer = ERB.new(template).result(binding)
        buffer += ssl_buffer
      end
      
      put buffer, "#{shared_path}/httpd.conf", :mode => 0444
      send(run_method, "cp #{shared_path}/httpd.conf #{apache_conf}")
      send(run_method, "rm -f #{shared_path}/httpd.conf")
    end
    
    desc "Start Apache "
    task :start, :roles => :web do
      send(run_method, "#{apache_ctl} start")
    end
    
    desc "Restart Apache "
    task :restart, :roles => :web do
      send(run_method, "#{apache_ctl} restart")
    end
    
    desc "Stop Apache "
    task :stop, :roles => :web do
      send(run_method, "#{apache_ctl} stop")
    end
    
    desc "Reload Apache "
    task :reload, :roles => :web do
      send(run_method, "#{apache_ctl} reload")
    end
  
  end
  
  def set_apache_conf
    if apache_default_vhost
      set :apache_conf, "/etc/httpd/conf/default.conf" unless apache_default_vhost_conf
    else 
      set :apache_conf, "/etc/httpd/conf/apps/#{application}.conf" unless apache_conf
    end
  end
  
end
