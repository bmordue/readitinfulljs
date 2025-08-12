# ReadItInFull.js - GitHub Copilot Instructions

**ALWAYS follow these instructions first and fallback to additional search and context gathering only if the information here is incomplete or found to be in error.**

ReadItInFull.js is a Node.js Express web application that implements Twitter OAuth authentication. It uses Jade templating, Passport.js for authentication, and the Twit library for Twitter API integration.

## Working Effectively

### Bootstrap, Build, and Run the Repository

**CRITICAL: All build and run commands MUST use Node.js 14.x. The application CANNOT run on Node.js 16+ due to Express 3.x compatibility requirements.**

1. **Install Node.js 14.x using NVM:**
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   nvm install 14
   nvm use 14
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```
   - **Duration:** ~25 seconds with Node.js 14.x
   - **NEVER CANCEL:** Wait for completion even if it takes longer
   - **Note:** Will show deprecation warnings - this is expected for this legacy application

3. **Create OAuth configuration file:**
   ```bash
   # Create oauth.js file with your Twitter API credentials
   cat > oauth.js << 'EOF'
   module.exports = {
       twitter: {
           consumerKey: 'YOUR_CONSUMER_KEY',
           consumerSecret: 'YOUR_CONSUMER_SECRET',
           callbackURL: 'http://localhost:1337/auth/twitter/callback'
       }
   };
   EOF
   ```
   - **CRITICAL:** This file is gitignored and MUST be created manually
   - Replace placeholder values with actual Twitter API credentials

4. **Start the application:**
   ```bash
   npm start
   ```
   - **Duration:** Starts immediately (~0.3 seconds)
   - **Port:** Application runs on http://localhost:1337
   - **Expected output:** "Express server listening on port 1337"
   - **Deprecation warnings:** Expected - shows Express 3.x deprecations

### Alternative Start Method
```bash
node app.js
```

## Validation

### Functional Testing Scenarios
**ALWAYS manually validate changes by testing these core scenarios:**

1. **Basic Application Access:**
   ```bash
   curl -I http://localhost:1337
   # Expected: HTTP 200 OK response
   ```

2. **Home Page Content:**
   ```bash
   curl http://localhost:1337
   # Expected: <a href="/auth/twitter">Login via Twitter</a>
   ```

3. **Users Endpoint:**
   ```bash
   curl http://localhost:1337/users
   # Expected: "respond with a resource"
   ```

4. **Authentication Redirect:**
   ```bash
   curl -I http://localhost:1337/account
   # Expected: HTTP 302 redirect to /
   ```

### Build Validation
- **NO build step required** - This is a standard Node.js Express application
- **NO test scripts defined** - No automated tests exist in this repository
- **NO linting configured** - No ESLint or similar tools configured

## Common Issues and Solutions

### Node.js Version Compatibility
- **Problem:** `TypeError: app.configure is not a function`
- **Solution:** MUST use Node.js 14.x. Express 3.x requires older Node.js
- **Fix:** Use `nvm use 14` before running any commands

### Missing oauth.js File
- **Problem:** `Cannot find module './oauth.js'`
- **Solution:** Create oauth.js file with Twitter API credentials (see bootstrap steps)
- **Note:** This file is intentionally gitignored for security

### Express Deprecation Warnings
- **Problem:** Multiple deprecation warnings shown
- **Solution:** These are expected - DO NOT attempt to fix them
- **Note:** Application uses legacy Express 3.x intentionally

## Timing Expectations

- **npm install:** 25 seconds with Node.js 14.x - NEVER CANCEL, set timeout to 60+ seconds
- **npm start:** <1 second startup time
- **Application response:** Immediate once started

## Repository Structure

### Key Files and Directories
```
/
├── app.js              # Main application entry point
├── package.json        # Dependencies and scripts
├── oauth.js           # Twitter API config (create manually, gitignored)
├── routes/            # Express route handlers
│   ├── index.js       # Home page route
│   └── user.js        # User-related routes
├── views/             # Jade templates
│   ├── layout.jade    # Base template
│   ├── login.jade     # Login page
│   └── account.jade   # User account page
└── public/            # Static assets
    └── stylesheets/   # CSS files
```

### Important Code Locations
- **Main server setup:** `app.js` lines 45-80
- **Twitter OAuth config:** `app.js` lines 29-42
- **Route definitions:** `app.js` lines 94-125
- **Authentication middleware:** `app.js` lines 87-92

## Dependencies and Technologies

### Core Stack
- **Express.js 3.x:** Web framework (legacy version for app.configure support)
- **Node.js 14.x:** JavaScript runtime (REQUIRED for compatibility)
- **Jade:** Templating engine (deprecated, now called Pug)
- **Passport.js:** Authentication middleware
- **Twit:** Twitter API client

### Authentication Flow
1. User clicks "Login via Twitter" on home page
2. Redirects to `/auth/twitter` (Passport.js handles OAuth)
3. Twitter redirects to `/auth/twitter/callback`
4. Successful auth redirects to `/account`
5. Logout available at `/logout`

## Troubleshooting Commands

### Check Node.js Version
```bash
node --version
# Must show v14.x.x
```

### Verify Dependencies
```bash
npm list express
# Should show express@3.21.2
```

### Check Application Health
```bash
# Test if server is responding
curl -f http://localhost:1337 || echo "Server not responding"
```

## Development Notes

- **MongoDB:** Imported but not used - mongoose dependency removed for compatibility
- **Security:** Contains multiple known vulnerabilities in dependencies (expected for legacy app)
- **Modernization:** This is a legacy application - avoid updating dependencies
- **Port Configuration:** Hardcoded to 1337, configurable via PORT environment variable

**Remember: ALWAYS use Node.js 14.x and follow the exact bootstrap sequence above.**