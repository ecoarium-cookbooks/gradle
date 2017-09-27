#
# Cookbook Name:: gradle
# Recipe:: default
#

#
# Apache 2.0
#

default[:gradle][:tests][:run] = false

default[:gradle][:source] = 'http://downloads.gradle.org/distributions/gradle-1.0-rc-3-all.zip'
default[:gradle][:version] = '1.0-rc-3'

case node.platform
when 'windows'
  default[:gradle][:dir] = '/usr/local/gradle'
else
  default[:gradle][:dir] = '/usr/local/gradle'
end
