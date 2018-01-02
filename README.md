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

### How to generate certificate

Run this locally: `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650`

Give it a password.
CN can be left blank.

## License

MIT
