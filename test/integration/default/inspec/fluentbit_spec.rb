control 'fluentbit-package-install' do
  title 'fluentbit'
  impact 1.0

  describe file('/etc/td-agent-bit/td-agent-bit.conf') do
    it { should be_file }
  end

  describe file('/etc/td-agent-bit/parsers-foo.conf') do
    it { should be_file }
  end

  describe file('/opt/td-agent-bit/bin/td-agent-bit') do
    it { should be_file }
  end

  describe command('/opt/td-agent-bit/bin/td-agent-bit --config /etc/td-agent-bit/td-agent-bit.conf') do
    its('stderr') { should match 'Fluent Bit' }
    its('stderr') { should match 'switching to background mode' }
  end
end
