#
# Cookbook:: fluentbit
# Recipe:: install
#

include_recipe "#{cookbook_name}::install_package" if node['fluentbit']['install_mode'] == 'package'
include_recipe "#{cookbook_name}::install_source" if node['fluentbit']['install_mode'] == 'source'

template "#{node['fluentbit']['conf_dir']}/#{node['fluentbit']['service_name']}.conf" do
  action :create_if_missing
  source 'fluent-bit.conf.erb'
  owner 'root'
  group 'root'
  mode '0400'
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

template "#{node['fluentbit']['conf_dir']}/parsers.conf" do
  action :create
  owner 'root'
  group 'root'
  mode '0400'
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

template "#{node['fluentbit']['conf_dir']}/_service.conf" do
  action :create_if_missing
  owner 'root'
  group 'root'
  mode '0400'
  variables(conf: node['fluentbit']['conf'])
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

systemd_unit node['fluentbit']['service_name'] do
  content <<-UNIT
    [Unit]
    Description=Fluent Bit
    Requires=network.target
    After=network.target

    [Service]
    Type=simple
    ExecStart=#{node['fluentbit']['install_dir']}/#{node['fluentbit']['service_name']} --config #{node['fluentbit']['conf_dir']}/#{node['fluentbit']['service_name']}.conf
    Restart=always

    [Install]
    WantedBy=multi-user.target
  UNIT

  action :create
  only_if { node['fluentbit']['install_mode'] == 'source' && node['init_package'] == 'systemd' } # XXX: skip with Docker
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

service node['fluentbit']['service_name'] do
  action :nothing
  only_if { node['init_package'] == 'systemd' } # XXX: skip with Docker
end
