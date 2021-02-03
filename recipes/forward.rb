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

directory '/var/lib/fluent-bit' do
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'systemd_unit[fluent-bit.service]'
end

fluentbit_conf 'forward' do
  content <<~CONF
    [INPUT]
        Name   kmsg
        Tag    #{node['fluentbit']['forward']['tag_prefix']}kmsg

    [INPUT]
        Name            systemd
        Tag             #{node['fluentbit']['forward']['tag_prefix']}systemd
        Read_From_Tail  On

    # XXX: Example with Monit:
    #
    # [INPUT]
    #     Name   tail
    #     Path   /var/log/monit.log
    #     DB     /var/lib/fluent-bit/monit.db
    #     Tag    #{node['fluentbit']['forward']['tag_prefix']}monit
    #     Parser monit

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

    # XXX: Uncomment to debug
    #
    # [OUTPUT]
    #     Name  stdout
    #     Match **
  CONF
end
