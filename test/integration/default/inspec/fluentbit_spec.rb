control 'fluentbit-1' do
  title 'fluentbit'
  impact 1.0

  describe file('/etc/fluent-bit/fluent-bit.conf') do
    it { should be_file }
  end

  describe file('/etc/fluent-bit/parsers-foo.conf') do
    it { should be_file }
  end

  describe file('/usr/local/bin/fluent-bit') do
    it { should be_file }
  end

  describe command('fluent-bit --config /etc/fluent-bit/fluent-bit.conf') do
    its('stderr') { should match 'Fluent Bit' }
    its('stderr') { should match 'switching to background mode' }
  end

  describe package('cmake-data') do
    # XXX: Make sure we auto-remove dependencies of the build dependencies
    it { should_not be_installed }
  end
end
