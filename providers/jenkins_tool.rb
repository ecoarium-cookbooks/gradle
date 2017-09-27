
action :add do
  require 'jenkins'

  url = @new_resource.jenkins_url || 'http://localhost:8080' #node[:jenkins][:server][:url]
  username = nil
  password = nil
  if ::JenkinsUtil.security_enabled("#{node['jenkins']['server']['home']}/config.xml")
    username = @new_resource.jenkins_username || node[:jenkins][:server][:username]
    password = @new_resource.jenkins_password || node[:jenkins][:server][:password]
  end
  tool_name = @new_resource.tool_name
  tool_home = @new_resource.tool_home
  
  cli = Motherscape::Jenkins::CLI.new(url, username, password)
  output = cli.groovy(<<"GROOVY_SCRIPT")
  	current_list = hudson.model.Hudson.getInstance().getDescriptorByType(hudson.plugins.gradle.Gradle.DescriptorImpl.class).getInstallations() as List;

  	existing_tool = current_list.find{it.name == "#{tool_name}"}
  	if (existing_tool) {
  		println "gradle tool configuration already exists: name='${existing_tool.name}', home='${existing_tool.home}'"
  	}
    else {
			current_list.add(new hudson.plugins.gradle.GradleInstallation("#{tool_name}", "#{tool_home}", null));
			hudson.plugins.gradle.GradleInstallation[] new_list = current_list.toArray(new hudson.plugins.gradle.GradleInstallation[current_list.size()]);
			hudson.model.Hudson.getInstance().getDescriptorByType(hudson.plugins.gradle.Gradle.DescriptorImpl.class).setInstallations(new_list);
  	}
GROOVY_SCRIPT
  puts output
  Chef::Application.fatal!("failed to configure gradle tool in jenkins") unless $?.exitstatus == 0
end
