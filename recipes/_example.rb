fluentbit_conf 'example' do
  content <<-CONF.gsub(/^[ ]{4}/, '')
    [INPUT]
        Name  cpu
        Tag   cpu

    [OUTPUT]
        Name  stdout
        Match *
  CONF
end
