#
# Cookbook:: fluentbit
# Recipe:: install_source
#

remote_file "#{Chef::Config[:file_cache_path]}/#{node['fluentbit']['archive']}" do
  source node['fluentbit']['url']
  checksum node['fluentbit']['checksum']
  owner 'root'
  group 'root'
  mode '0644'
  notifies :install, 'package[install_dependencies]', :immediately
  notifies :run, 'bash[install_fluentbit]', :immediately
  notifies :purge, 'package[uninstall_dependencies]', :immediately
end

# Force update packages before installing
apt_update 'update' do
  action :nothing
end

package 'install_dependencies' do
  action :nothing
  package_name node['fluentbit']['dependencies']
  notifies :update, 'apt_update[update]', :before
end

package 'uninstall_dependencies' do
  action :nothing
  package_name node['fluentbit']['dependencies']
  options '--auto-remove'
  only_if { node['fluentbit']['uninstall_dependencies'] }
end

bash 'install_fluentbit' do
  action :nothing
  user 'root'
  group 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-BASH
    set -eux
    tar xf #{node['fluentbit']['archive']}
    cd fluent-bit-#{node['fluentbit']['version']}/build
    cmake .. #{node['fluentbit']['cmake_flags']}
    make #{node['fluentbit']['make_flags']}
    install --strip -m 0755 -t #{node['fluentbit']['install_dir']} bin/fluent-bit
  BASH
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

directory node['fluentbit']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
end
