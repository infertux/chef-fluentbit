#
# Cookbook:: fluentbit
# Recipe:: install
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

package 'install_dependencies' do
  action :nothing
  package_name node['fluentbit']['dependencies']
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
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

directory node['fluentbit']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
end

template "#{node['fluentbit']['conf_dir']}/fluent-bit.conf" do
  action :create_if_missing
  owner 'root'
  group 'root'
  mode '0400'
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

template "#{node['fluentbit']['conf_dir']}/parsers.conf" do
  owner 'root'
  group 'root'
  mode '0400'
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

template "#{node['fluentbit']['conf_dir']}/_service.conf" do
  action :create_if_missing
  owner 'root'
  group 'root'
  mode '0400'
  variables(conf: node['fluentbit']['conf'])
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

systemd_unit 'fluent-bit.service' do
  content <<-UNIT
    [Unit]
    Description=Fluent Bit
    Requires=network.target
    After=network.target

    [Service]
    Type=simple
    ExecStart=#{node['fluentbit']['install_dir']}/fluent-bit --config #{node['fluentbit']['conf_dir']}/fluent-bit.conf
    Restart=always

    [Install]
    WantedBy=multi-user.target
  UNIT

  action %i(create enable)
  notifies :restart, 'systemd_unit[fluent-bit.service]'
  only_if { node['init_package'] == 'systemd' } # XXX: skip with Docker
end
