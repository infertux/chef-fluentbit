#
# Cookbook:: fluentbit
# Recipe:: install
#

include_recipe "#{cookbook_name}::install_#{node['fluentbit']['install_mode']}"

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

systemd_unit "#{node['fluentbit']['service_name']}.service" do
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

  action %w(create enable)
  only_if { node['init_package'] == 'systemd' } # XXX: skip with Docker
  notifies :restart, "service[#{node['fluentbit']['service_name']}]"
end

service node['fluentbit']['service_name'] do
  action :nothing
  only_if { node['init_package'] == 'systemd' } # XXX: skip with Docker
end
