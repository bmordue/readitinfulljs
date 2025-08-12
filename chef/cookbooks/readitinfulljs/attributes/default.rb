# Default attributes for readitinfulljs cookbook

# Node.js version
default['nodejs']['version'] = '16.x'
default['nodejs']['install_method'] = 'package'

# MongoDB version  
default['mongodb']['version'] = '4.4'

# Application settings
default['readitinfulljs']['app_dir'] = '/opt/readitinfulljs'
default['readitinfulljs']['user'] = 'app'
default['readitinfulljs']['group'] = 'app'
default['readitinfulljs']['port'] = 1337

# Git repository
default['readitinfulljs']['git_repository'] = 'https://github.com/bmordue/readitinfulljs.git'
default['readitinfulljs']['git_revision'] = 'master'

# Twitter OAuth (override these with environment-specific values)
default['readitinfulljs']['twitter']['consumer_key'] = nil
default['readitinfulljs']['twitter']['consumer_secret'] = nil
default['readitinfulljs']['twitter']['callback_url'] = 'http://localhost:1337/auth/twitter/callback'