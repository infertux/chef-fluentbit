control 'fluentbit-1' do
  title 'fluentbit'
  impact 1.0

  describe file('/etc/fluent-bit/fluent-bit.conf') do
    it { should be_file }
  end

  describe file('/usr/local/bin/fluent-bit') do
    it { should be_file }
  end

  describe command('fluent-bit') do
    it { should exist }
  end
end
