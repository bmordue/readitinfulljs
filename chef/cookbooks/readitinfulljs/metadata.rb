name 'readitinfulljs'
maintainer 'ReadItInFull Team'
maintainer_email 'team@readitinfull.com'
license 'MIT'
description 'Installs and configures ReadItInFull.js application'
long_description 'Cookbook for provisioning the ReadItInFull.js Node.js application with all dependencies including MongoDB and Node.js'
version '0.1.0'
chef_version '>= 14.0'

supports 'ubuntu', '>= 18.04'
supports 'centos', '>= 7.0'

depends 'nodejs'
depends 'mongodb'