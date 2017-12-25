#
# Cookbook:: fluentbit
# Recipe:: default
#

package %w[make cmake g++]

remote_file "#{Chef::Config[:file_cache_path]}/#{node['fluentbit']['archive']}" do
  source node['fluentbit']['url']
  checksum node['fluentbit']['checksum']
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'bash[install_fluentbit]', :immediately
end

bash 'install_fluentbit' do
  action :nothing
  user 'root'
  group 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-BASH
    set -eux
    tar xvf #{node['fluentbit']['archive']}
    cd fluent-bit-#{node['fluentbit']['version']}/build
    cmake ..
    make
    install --strip -m 0755 -t #{node['fluentbit']['install_dir']} bin/fluent-bit
  BASH
end

directory node['fluentbit']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
end

template "#{node['fluentbit']['conf_dir']}/fluent-bit.conf" do
  owner 'root'
  group 'root'
  mode '0400'
  variables(conf: node['fluentbit']['conf'])
end

systemd_unit 'fluent-bit.service' do
  content <<-UNIT
    [Unit]
    Description=Fluent Bit
    Requires=network.target
    After=network.target

    [Service]
    Type=simple
    ExecStart=#{node['fluentbit']['install_dir']}/fluent-bit
    Restart=always

    [Install]
    WantedBy=multi-user.target
  UNIT

  subscribes :restart, "template[#{node['fluentbit']['conf_dir']}/fluent-bit.conf]"
  action %i[create enable start]
  only_if 'test -f /bin/systemctl && /bin/systemctl' # XXX: skip with Docker
end
