fluentbit_conf 'monit' do
  content <<~CONF
    [INPUT]
        Name   tail
        Path   /var/log/monit.log
        DB     /var/lib/fluent-bit/monit.db
        Skip_Long_Lines On
        Tag    #{node['fluentbit']['forward']['tag_prefix']}monit
        Parser monit
  CONF
end
