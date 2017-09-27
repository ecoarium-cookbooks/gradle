# Resource
actions :add
default_action :add

attribute :jenkins_url, :kind_of => String
attribute :jenkins_username, :kind_of => String
attribute :jenkins_password, :kind_of => String
attribute :tool_name, :kind_of => String, :name_attribute => true
attribute :tool_home, :kind_of => String, :required => true
