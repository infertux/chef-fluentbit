#
# Cookbook:: fluentbit
# Recipe:: forward
#

file "#{node['fluentbit']['conf_dir']}/cert.pem" do
  owner 'root'
  group 'root'
  mode '0400'
  content node['fluentbit']['forward'].fetch('cert')
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

directory '/var/run/fluent-bit' do
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

fluentbit_conf 'forward' do
  content <<-CONF.gsub(/^[ ]{4}/, '')
    [INPUT]
        Name   kmsg
        Tag    #{node['fluentbit']['forward']['tag_prefix']}kmsg

    [INPUT]
        Name   systemd
        Tag    #{node['fluentbit']['forward']['tag_prefix']}systemd

    [INPUT]
        Name   tail
        Path   /var/log/monit.log
        Tag    #{node['fluentbit']['forward']['tag_prefix']}monit
        Parser monit
        DB     /var/run/fluent-bit/monit.db

    [OUTPUT]
        Name            forward
        Match           **
        Host            #{node['fluentbit']['forward']['host']}
        Port            #{node['fluentbit']['forward']['port']}
        Time_as_Integer True
        Shared_Key      #{node['fluentbit']['forward']['shared_key']}
        tls             On
        tls.verify      Off # don't check CA since it's a self-signed cert
        tls.ca_file    #{node['fluentbit']['conf_dir']}/cert.pem

    # [OUTPUT]
    #     Name  stdout
    #     Match **
  CONF
end