include_recipe "apache2"
package "apache2-threaded-dev"

gem_package "passenger" do
  version node[:passenger_version]
  action :upgrade
end

execute "passenger_module" do
  command 'echo -en "\n\n" | passenger-install-apache2-module --auto'
  creates node[:passenger][:module_path]
end

template node[:passenger][:apache_load_path] do
  source "passenger.load.erb"
  owner "root"
  group "root"
  mode 0755
end

template node[:passenger][:apache_conf_path] do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode 0755
end

apache_module "passenger"

apache_site "000-default" do
  enable false
end

ssl_enabled = false


if node[:apps]
  node[:apps].each do |appconf|
    app = appconf[:name]
    env = appconf[:env]
    site =  "#{app}_#{env}"

    if configs = node[:apache][app]
      configs = [configs] if configs.is_a?(Hash)
      configs.each do |config|
        site << "_ssl" if config[:ssl]

        template "/etc/apache2/sites-available/#{site}" do
          owner 'root'
          group 'root'
          mode 0644
          source "application.vhost#{'.ssl' if config[:ssl]}.erb"
          variables({
            :docroot => "/data/#{app}/current/public",
            :server_name => config[:server_name],
            :max_pool_size => config[:max_pool_size] || 2,
            :env => env,
            :aliases => config[:aliases],
            :app => app,
            :rewrites => config[:rewrites],
            :certs => config[:certs]
          })
          notifies :reload, resources(:service => "apache2")
        end

        enable_flag = config[:enable] # get around a weird bug where inside the block, node was []
        apache_site site do
          enable enable_flag
        end

        ssl_enabled = true if config[:ssl]
      end
    end
  end
end

include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl" if ssl_enabled
