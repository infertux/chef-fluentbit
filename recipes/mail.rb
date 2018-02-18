fluentbit_conf 'mail' do
  content <<-CONF.gsub(/^[ ]{4}/, '')
    [INPUT]
        Name   tail
        Path   /var/log/mail.err
        DB     /var/lib/fluent-bit/mail.db
        Skip_Long_Lines On
        Tag    #{node['fluentbit']['forward']['tag_prefix']}mail.err
  CONF
end
