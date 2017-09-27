#
# Cookbook Name:: gradle
# Recipe:: default
#

gradledir = node[:gradle][:dir]
file_name = File.basename(node[:gradle][:source])
dest_file = File.join(Chef::Config[:file_cache_path], file_name)

case node.platform
when 'windows'
  directory gradledir do
	recursive true
    inherits true
    action :create
  end
  
  windows_zipfile gradledir do
    source node[:gradle][:source]
    action :unzip
    not_if {File.exists?("#{gradledir}/gradle-#{node[:gradle][:version]}/bin/gradle.bat")}
  end
else
  directory gradledir do
    mode '0755'
    action :create
  end
  
  remote_file dest_file do
    source node[:gradle][:source]
    checksum node[:gradle][:checksum] if node[:gradle].has_key? 'checksum'
    not_if {File.exists?("#{gradledir}/gradle-#{node[:gradle][:version]}/bin/gradle.bat")}
  end
  
  execute 'uzip_gradle' do
    command "jar xf #{dest_file}"
    cwd gradledir
    creates "#{gradledir}/gradle-#{node[:gradle][:version]}/bin/gradle.bat"
    action :run
  end
end

if node.platform != 'windows'
  %w{gradle}.each do |script|
    file "#{gradledir}/gradle-#{node[:gradle][:version]}/bin/#{script}" do
      mode '0755'
      action :create
    end
  end
end
