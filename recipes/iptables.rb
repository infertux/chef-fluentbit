fluentbit_conf 'iptables' do
  content <<-CONF.gsub(/^[ ]{4}/, '')
    [INPUT]
        Name   tail
        Path   /var/log/iptables.log
        DB     /var/lib/fluent-bit/iptables.db
        Skip_Long_Lines On
        Tag    #{node['fluentbit']['forward']['tag_prefix']}iptables

    [FILTER]
        Name   grep
        Match  #{node['fluentbit']['forward']['tag_prefix']}kmsg
        Exclude msg iptables:

    [FILTER]
        Name   grep
        Match  #{node['fluentbit']['forward']['tag_prefix']}systemd
        Exclude MESSAGE iptables:
  CONF
end
