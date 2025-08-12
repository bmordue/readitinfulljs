# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Ubuntu 20.04 LTS
  config.vm.box = "ubuntu/focal64"
  
  # Configure VM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "readitinfulljs-dev"
  end
  
  # Network configuration
  config.vm.network "forwarded_port", guest: 1337, host: 1337
  config.vm.network "forwarded_port", guest: 27017, host: 27017
  
  # Shared folder
  config.vm.synced_folder ".", "/vagrant"
  
  # Provisioning with shell script
  config.vm.provision "shell", inline: <<-SHELL
    echo "Updating system packages..."
    apt-get update
    
    echo "Installing curl and wget..."
    apt-get install -y curl wget gnupg2 software-properties-common
    
    echo "Installing Node.js 16.x..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
    apt-get install -y nodejs
    
    echo "Installing MongoDB..."
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
    apt-get update
    apt-get install -y mongodb-org
    
    echo "Starting MongoDB service..."
    systemctl enable mongod
    systemctl start mongod
    
    echo "Installing application dependencies..."
    cd /vagrant
    npm install
    
    echo "Creating sample oauth.js configuration..."
    if [ ! -f oauth.js ]; then
      cat > oauth.js << 'EOF'
// OAuth configuration template
// Replace with your actual Twitter API credentials
module.exports = {
  twitter: {
    consumerKey: process.env.TWITTER_CONSUMER_KEY || 'your_consumer_key',
    consumerSecret: process.env.TWITTER_CONSUMER_SECRET || 'your_consumer_secret',
    callbackURL: process.env.TWITTER_CALLBACK_URL || 'http://localhost:1337/auth/twitter/callback'
  }
};
EOF
    fi
    
    echo "Setting up environment..."
    echo 'export NODE_ENV=development' >> /home/vagrant/.bashrc
    echo 'cd /vagrant' >> /home/vagrant/.bashrc
    
    echo "=== Setup Complete ==="
    echo "Node.js version: $(node --version)"
    echo "NPM version: $(npm --version)"
    echo "MongoDB version: $(mongod --version | head -n1)"
    echo ""
    echo "To start the application:"
    echo "  vagrant ssh"
    echo "  cd /vagrant"
    echo "  npm start"
    echo ""
    echo "The application will be available at http://localhost:1337"
  SHELL
end