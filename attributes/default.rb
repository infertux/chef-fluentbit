# XXX: see https://fluentbit.io/download/ for latest version
# Only used for source install mode
default['fluentbit']['version'] = '1.6.10'
default['fluentbit']['checksum'] = 'd5101f31e1aadd5b5df769957651e59d0996df719c1be8219b70cf32ed9ad92e'
default['fluentbit']['archive'] = "fluent-bit-#{default['fluentbit']['version']}.tar.gz"
default['fluentbit']['url'] = "https://fluentbit.io/releases/#{default['fluentbit']['version'].split('.')[0..-2].join('.')}/#{default['fluentbit']['archive']}"

default['fluentbit']['dependencies'] = %w(make cmake g++ pkg-config bison flex)
default['fluentbit']['dependencies'] << 'libsystemd-dev' # required for systemd input plugin
default['fluentbit']['uninstall_dependencies'] = true # clean up deps after source installation?
default['fluentbit']['make_flags'] = '-j $(nproc)'
default['fluentbit']['cmake_flags'] = '-DFLB_IN_HTTP=no' # https://github.com/fluent/fluent-bit/issues/2930

default['fluentbit']['install_mode'] = 'package'

if node['fluentbit']['install_mode'] == 'package'
  default['fluentbit']['install_dir'] = '/opt/td-agent-bit/bin'
  default['fluentbit']['service_name'] = 'td-agent-bit'
  default['fluentbit']['conf_dir'] = '/etc/td-agent-bit'
  default['fluentbit']['lib_dir'] = '/lib/td-agent-bit'
else
  default['fluentbit']['install_dir'] = '/usr/local/bin'
  default['fluentbit']['service_name'] = 'fluent-bit'
  default['fluentbit']['conf_dir'] = '/etc/fluent-bit'
  default['fluentbit']['lib_dir'] = '/var/lib/fluent-bit'
end

default['fluentbit']['conf']['Flush'] = 5
default['fluentbit']['conf']['Daemon'] = 'Off'
default['fluentbit']['conf']['Log_Level'] = 'info'

default['fluentbit']['forward']['host'] = '' # required
default['fluentbit']['forward']['port'] = 24_224
default['fluentbit']['forward']['self_hostname'] = 'localhost'
default['fluentbit']['forward']['shared_key'] = '' # required
default['fluentbit']['forward']['tag_prefix'] = '' # optional
