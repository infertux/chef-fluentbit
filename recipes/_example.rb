fluentbit_conf 'example' do
  content <<~CONF
    [INPUT]
        Name  cpu
        Tag   cpu

    [OUTPUT]
        Name  stdout
        Match *
  CONF
end

fluentbit_conf 'foo' do
  type :parser
  content <<~CONF
    [PARSER]
        Name   foo
        Format regex
        Regex  ^(?<foo>[^ ]*) [^ ]*$
  CONF
end
