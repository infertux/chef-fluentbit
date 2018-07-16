property :content, String, required: true
property :type, Symbol, required: false, default: :conf, equal_to: %i(conf parser)

default_action :create

def include_line(resource)
  case resource.type
  when :conf
    "@INCLUDE #{resource.name}.conf"
  when :parser
    "    Parsers_File parsers-#{resource.name}.conf"
  else raise
  end
end

def include_file(resource)
  case resource.type
  when :conf
    "#{node['fluentbit']['conf_dir']}/fluent-bit.conf"
  when :parser
    "#{node['fluentbit']['conf_dir']}/_service.conf"
  else raise
  end
end

def conf_file(resource)
  case resource.type
  when :conf then
    "#{node['fluentbit']['conf_dir']}/#{resource.name}.conf"
  when :parser then
    "#{node['fluentbit']['conf_dir']}/parsers-#{resource.name}.conf"
  else raise
  end
end

action :create do
  file conf_file(new_resource) do
    owner 'root'
    group 'root'
    mode '0400'
    content new_resource.content
    notifies :restart, 'systemd_unit[fluent-bit.service]'
  end

  line = include_line new_resource
  file = include_file new_resource

  execute "append #{line}" do
    user 'root'
    group 'root'
    not_if "grep -E '^#{line}' #{file}"
    command "echo '#{line}' >> #{file}"
    notifies :restart, 'systemd_unit[fluent-bit.service]'
  end
end

action :delete do
  file conf_file(new_resource) do
    action :delete
    notifies :restart, 'systemd_unit[fluent-bit.service]'
  end

  ruby_block "delete #{include_line new_resource}" do
    block do
      line = include_line new_resource

      conf = Chef::Util::FileEdit.new(include_file(new_resource))
      conf.search_file_delete_line(/\A#{line}/)
      conf.write_file
    end
  end
end
