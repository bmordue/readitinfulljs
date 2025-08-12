# Use Node.js official image - using Node 18 to avoid dependency issues
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package*.json ./

# Install dependencies with npm registry fix
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set strict-ssl false && \
    npm install

# Copy application code
COPY . .

# Create a sample oauth.js file (template) if it doesn't exist
RUN if [ ! -f oauth.js ]; then \
      echo "// OAuth configuration template" > oauth.js && \
      echo "// Replace with your actual Twitter API credentials" >> oauth.js && \
      echo "module.exports = {" >> oauth.js && \
      echo "  twitter: {" >> oauth.js && \
      echo "    consumerKey: process.env.TWITTER_CONSUMER_KEY || 'your_consumer_key'," >> oauth.js && \
      echo "    consumerSecret: process.env.TWITTER_CONSUMER_SECRET || 'your_consumer_secret'," >> oauth.js && \
      echo "    callbackURL: process.env.TWITTER_CALLBACK_URL || 'http://localhost:1337/auth/twitter/callback'" >> oauth.js && \
      echo "  }" >> oauth.js && \
      echo "};" >> oauth.js; \
    fi

# Expose port
EXPOSE 1337

# Start the Node.js application
CMD ["npm", "start"]