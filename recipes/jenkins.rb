#
# Cookbook Name:: gradle
# Recipe:: jeknins
#
 
#
# Apache 2.0 
#

require 'chef/mixin/command'

ruby_block "block_until_jenkins_back_up" do
  block do
    sleep 10
    1.upto(10).each{ |c|
      Chef::Log.info('Waiting for jenkins to be available: count: ' +  c.to_s)

      begin
        jenkins_command('help', node)
        break
      rescue
        sleep 10
      end
    }
  end
  action :nothing
end

jenkins_cli "safe-restart" do
  url 'http://localhost:8080'
  action :nothing
  notifies :create, resources(:ruby_block => "block_until_jenkins_back_up"), :immediately
end

jenkins_cli "install-plugin #{File.expand_path('../files/default/gradle.jpi', File.dirname(__FILE__))}" do
  url 'http://localhost:8080'
  not_if {Jenkins.plugins.include? 'gradle'}
  notifies :run, resources(:jenkins_cli => "safe-restart"), :immediately
end

gradle_jenkins_tool "gradle-#{node['gradle']['version']}" do
  tool_home "#{node['gradle']['dir']}/gradle-#{node['gradle']['version']}"
end