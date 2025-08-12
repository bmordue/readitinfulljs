#
# Cookbook:: readitinfulljs
# Recipe:: default
#
# Installs and configures ReadItInFull.js application

# Update package cache
apt_update 'update' if platform_family?('debian')

# Install system dependencies
package 'curl'
package 'wget'
package 'git'
package 'build-essential' if platform_family?('debian')

# Install Node.js
case node['platform_family']
when 'debian'
  # Add NodeSource repository
  execute 'add_nodesource_repo' do
    command 'curl -fsSL https://deb.nodesource.com/setup_16.x | bash -'
    not_if 'which node'
  end
  
  package 'nodejs'
  
when 'rhel'
  # Add NodeSource repository for RHEL/CentOS
  execute 'add_nodesource_repo' do
    command 'curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -'
    not_if 'which node'
  end
  
  package 'nodejs'
end

# Install MongoDB
case node['platform_family']
when 'debian'
  # Add MongoDB repository key and source
  execute 'add_mongodb_key' do
    command 'wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -'
    not_if 'apt-key list | grep MongoDB'
  end
  
  file '/etc/apt/sources.list.d/mongodb-org-4.4.list' do
    content 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse'
    not_if { ::File.exist?('/etc/apt/sources.list.d/mongodb-org-4.4.list') }
    notifies :run, 'execute[apt_update_mongodb]', :immediately
  end
  
  execute 'apt_update_mongodb' do
    command 'apt-get update'
    action :nothing
  end
  
  package 'mongodb-org'

when 'rhel'
  # Create MongoDB repository file for RHEL/CentOS
  file '/etc/yum.repos.d/mongodb-org-4.4.repo' do
    content <<~EOF
      [mongodb-org-4.4]
      name=MongoDB Repository
      baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
      gpgcheck=1
      enabled=1
      gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
    EOF
    not_if { ::File.exist?('/etc/yum.repos.d/mongodb-org-4.4.repo') }
  end
  
  package 'mongodb-org'
end

# Start and enable MongoDB service
service 'mongod' do
  action [:enable, :start]
end

# Create application user
user node['readitinfulljs']['user'] do
  group node['readitinfulljs']['group']
  system true
  home node['readitinfulljs']['app_dir']
  shell '/bin/bash'
end

group node['readitinfulljs']['group'] do
  system true
end

# Create application directory
directory node['readitinfulljs']['app_dir'] do
  owner node['readitinfulljs']['user']
  group node['readitinfulljs']['group']
  mode '0755'
  recursive true
end

# Clone or update application repository
git node['readitinfulljs']['app_dir'] do
  repository node['readitinfulljs']['git_repository']
  revision node['readitinfulljs']['git_revision']
  user node['readitinfulljs']['user']
  group node['readitinfulljs']['group']
  action :sync
end

# Install npm dependencies
execute 'npm_install' do
  command 'npm install'
  cwd node['readitinfulljs']['app_dir']
  user node['readitinfulljs']['user']
  group node['readitinfulljs']['group']
  environment 'HOME' => node['readitinfulljs']['app_dir']
end

# Create OAuth configuration file from template
template "#{node['readitinfulljs']['app_dir']}/oauth.js" do
  source 'oauth.js.erb'
  owner node['readitinfulljs']['user']
  group node['readitinfulljs']['group']
  mode '0600'
  variables(
    consumer_key: node['readitinfulljs']['twitter']['consumer_key'] || 'your_consumer_key',
    consumer_secret: node['readitinfulljs']['twitter']['consumer_secret'] || 'your_consumer_secret',
    callback_url: node['readitinfulljs']['twitter']['callback_url']
  )
end

# Create systemd service file
template '/etc/systemd/system/readitinfulljs.service' do
  source 'readitinfulljs.service.erb'
  mode '0644'
  variables(
    app_dir: node['readitinfulljs']['app_dir'],
    user: node['readitinfulljs']['user'],
    group: node['readitinfulljs']['group'],
    port: node['readitinfulljs']['port']
  )
  notifies :run, 'execute[systemctl_daemon_reload]', :immediately
end

execute 'systemctl_daemon_reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

# Enable and start the service
service 'readitinfulljs' do
  action [:enable, :start]
end

# Open firewall port if firewall is active
execute 'open_firewall_port' do
  command "ufw allow #{node['readitinfulljs']['port']}"
  only_if 'which ufw && ufw status | grep -q "Status: active"'
end