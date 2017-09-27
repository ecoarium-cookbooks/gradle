name             "gradle"
maintainer       "Jay Flowers"
maintainer_email "jay.flowers@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures gradle"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.4"

%w{ windows }.each do |os|
  supports os
end

depends "windows"
