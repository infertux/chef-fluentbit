# fluentbit cookbook

[![Build Status](https://travis-ci.org/infertux/chef-fluentbit.svg?branch=master)](https://travis-ci.org/infertux/chef-fluentbit)

## Recipe `default`

The recipe `fluentbit::default` installs [Fluent Bit](http://fluentbit.io).

You can add custom configuration with the `fluentbit_conf` helper:

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

## Recipe `forward`

A simple generic recipe is available to set up forwarding to another Fluent Bit or Fluentd host.

### How to generate certificate for secure forwarding

Run this locally: `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650`

Give it a password.
CN can be left blank.

## License

MIT
