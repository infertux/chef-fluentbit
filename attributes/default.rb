# XXX: see https://fluentbit.io/download/ for latest version
default['fluentbit']['version'] = '1.3.2'
default['fluentbit']['checksum'] = '12684fd77ff8ac98d9d66c1840761a250118bc5305b5496f6f8f9110478beb95'
default['fluentbit']['archive'] = "fluent-bit-#{default['fluentbit']['version']}.tar.gz"
default['fluentbit']['url'] = "https://fluentbit.io/releases/#{default['fluentbit']['version'].split('.')[0..-2].join('.')}/#{default['fluentbit']['archive']}"

default['fluentbit']['dependencies'] = %w(make cmake g++ pkg-config bison flex)
default['fluentbit']['dependencies'] << 'libsystemd-dev' # required for systemd input plugin
default['fluentbit']['uninstall_dependencies'] = true # clean up deps after installation?
default['fluentbit']['make_flags'] = '-j $(nproc)'

default['fluentbit']['install_dir'] = '/usr/local/bin'
default['fluentbit']['conf_dir'] = '/etc/fluent-bit'

default['fluentbit']['conf']['Flush'] = 5
default['fluentbit']['conf']['Daemon'] = 'Off'
default['fluentbit']['conf']['Log_Level'] = 'info'

default['fluentbit']['forward']['host'] = '' # required
default['fluentbit']['forward']['port'] = 24_224
default['fluentbit']['forward']['self_hostname'] = 'localhost'
default['fluentbit']['forward']['shared_key'] = '' # required
default['fluentbit']['forward']['tag_prefix'] = '' # optional
