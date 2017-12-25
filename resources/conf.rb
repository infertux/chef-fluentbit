property :content, String, required: true

default_action :create

def include_line(resource)
  "@INCLUDE #{resource.name}.conf"
end

action :create do
  file "#{node['fluentbit']['conf_dir']}/#{new_resource.name}.conf" do
    owner 'root'
    group 'root'
    mode '0400'
    content new_resource.content
    notifies :restart, 'systemd_unit[fluent-bit.service]'
  end

  ruby_block "append #{include_line new_resource}" do
    block do
      line = include_line new_resource

      conf = Chef::Util::FileEdit.new("#{node['fluentbit']['conf_dir']}/fluent-bit.conf")
      conf.insert_line_if_no_match(/\A#{line}/, line)
      conf.write_file
    end
  end
end

action :delete do
  file "#{node['fluentbit']['conf_dir']}/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, 'systemd_unit[fluent-bit.service]'
  end

  ruby_block "delete #{include_line new_resource}" do
    block do
      line = include_line new_resource

      conf = Chef::Util::FileEdit.new("#{node['fluentbit']['conf_dir']}/fluent-bit.conf")
      conf.search_file_delete_line(/\A#{line}/)
      conf.write_file
    end
  end
end
