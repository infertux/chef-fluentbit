# fluentbit cookbook

The recipe `fluentbit::default` installs [Fluent Bit](http://fluentbit.io).

## Usage

```ruby
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
```

## License

MIT
