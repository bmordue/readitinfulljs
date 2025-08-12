# Quick Start Guide for ReadItInFull.js

This document provides multiple ways to quickly get the ReadItInFull.js application running on your development environment.

## Prerequisites

Before using any of the quick start methods, you'll need:

1. **Twitter API Credentials**: Register your application at [Twitter Developer Portal](https://developer.twitter.com/) to get:
   - Consumer Key
   - Consumer Secret
   - Callback URL (default: `http://localhost:1337/auth/twitter/callback`)

## Quick Start Options

### Option 1: Docker Compose (Recommended)

The easiest way to get started with all dependencies handled automatically.

**Requirements:**
- Docker
- Docker Compose

**Steps:**
1. Clone the repository
2. Set your Twitter API credentials:
   ```bash
   export TWITTER_CONSUMER_KEY="your_actual_consumer_key"
   export TWITTER_CONSUMER_SECRET="your_actual_consumer_secret" 
   export TWITTER_CALLBACK_URL="http://localhost:1337/auth/twitter/callback"
   ```
3. Start the application:
   ```bash
   docker-compose up -d
   ```
4. Open http://localhost:1337 in your browser

**To stop:**
```bash
docker-compose down
```

### Option 2: Docker (Standalone)

Use Docker without external MongoDB dependency.

**Requirements:**
- Docker

**Steps:**
1. Build the image:
   ```bash
   docker build -t readitinfulljs .
   ```
2. Run the container:
   ```bash
   docker run -p 1337:1337 \
     -e TWITTER_CONSUMER_KEY="your_actual_consumer_key" \
     -e TWITTER_CONSUMER_SECRET="your_actual_consumer_secret" \
     readitinfulljs
   ```
3. Open http://localhost:1337 in your browser

### Option 3: Vagrant

Use a virtual machine with all dependencies pre-installed.

**Requirements:**
- Vagrant
- VirtualBox (or another Vagrant provider)

**Steps:**
1. Start the VM:
   ```bash
   vagrant up
   ```
2. SSH into the VM:
   ```bash
   vagrant ssh
   ```
3. Edit the OAuth configuration:
   ```bash
   cd /vagrant
   nano oauth.js  # Replace placeholder credentials with your actual ones
   ```
4. Start the application:
   ```bash
   npm start
   ```
5. Open http://localhost:1337 in your browser (on your host machine)

**To stop:**
```bash
vagrant halt
```

**To destroy the VM:**
```bash
vagrant destroy
```

### Option 4: Chef Provisioning

Use Chef for automated server provisioning (suitable for production environments).

**Requirements:**
- Chef Workstation
- Target server (Ubuntu 18.04+ or CentOS 7+)

**Steps:**

1. Install dependencies:
   ```bash
   cd chef
   berks install
   ```

2. Create a nodes file (e.g., `nodes/myserver.json`):
   ```json
   {
     "name": "myserver",
     "chef_environment": "_default",
     "run_list": ["recipe[readitinfulljs::default]"],
     "override_attributes": {
       "readitinfulljs": {
         "twitter": {
           "consumer_key": "your_actual_consumer_key",
           "consumer_secret": "your_actual_consumer_secret",
           "callback_url": "http://your-server:1337/auth/twitter/callback"
         }
       }
     }
   }
   ```

3. Bootstrap and provision your server:
   ```bash
   knife bootstrap YOUR_SERVER_IP \
     --ssh-user YOUR_USER \
     --sudo \
     --node-name myserver \
     --run-list "recipe[readitinfulljs::default]"
   ```

4. The application will be available at `http://YOUR_SERVER_IP:1337`

## Configuration

### Environment Variables

The application supports the following environment variables:

- `PORT`: Application port (default: 1337)
- `NODE_ENV`: Node.js environment (development/production)
- `TWITTER_CONSUMER_KEY`: Twitter API consumer key
- `TWITTER_CONSUMER_SECRET`: Twitter API consumer secret
- `TWITTER_CALLBACK_URL`: Twitter OAuth callback URL
- `MONGODB_URI`: MongoDB connection string (for docker-compose)

### OAuth Configuration

For local development, you can manually create an `oauth.js` file:

```javascript
module.exports = {
  twitter: {
    consumerKey: 'your_actual_consumer_key',
    consumerSecret: 'your_actual_consumer_secret',
    callbackURL: 'http://localhost:1337/auth/twitter/callback'
  }
};
```

**Important:** Never commit real API credentials to version control!

## Troubleshooting

### Common Issues

1. **Application won't start**: Check that MongoDB is running and accessible
2. **OAuth errors**: Verify your Twitter API credentials are correct
3. **Port conflicts**: Change the port using the `PORT` environment variable
4. **Permission errors (Chef)**: Ensure your user has sudo privileges

### Checking Logs

**Docker Compose:**
```bash
docker-compose logs app
docker-compose logs mongodb
```

**Vagrant:**
```bash
vagrant ssh
sudo journalctl -u readitinfulljs -f  # If using systemd
```

**Chef (systemd):**
```bash
sudo journalctl -u readitinfulljs -f
```

## Development

For development with file watching and auto-restart:

1. Use the Vagrant environment for closest-to-production setup
2. Or use Docker with volume mounting:
   ```bash
   docker run -p 1337:1337 -v $(pwd):/app readitinfulljs
   ```

## Next Steps

- Configure your Twitter app settings in the Twitter Developer Portal
- Set up proper production MongoDB instances for production deployments
- Consider using environment-specific configuration files
- Set up monitoring and logging for production environments