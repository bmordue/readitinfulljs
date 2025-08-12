# ReadItInFull JavaScript Application

ReadItInFull is a Node.js/Express web application that implements Twitter OAuth authentication for reading content. The application uses MongoDB for data persistence and provides a Twitter-based authentication flow.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Build
- Install dependencies: `npm install` -- takes 2 seconds. NEVER CANCEL.
- **CRITICAL COMPATIBILITY ISSUE**: The original code uses deprecated Express 3.x patterns (`app.configure()`) that do not work with modern Node.js versions (v20+)
- To run the application, you MUST install additional middleware packages: `npm install morgan cookie-parser body-parser method-override express-session errorhandler`
- **Build time**: npm install completes in 1-2 seconds consistently

### Database Setup
- **MongoDB is REQUIRED**: The application depends on MongoDB but does not include connection logic in main files
- Install MongoDB via Docker: `docker run --name mongodb -d -p 27017:27017 mongo:4.4`
- Docker pull time: 2-3 minutes for MongoDB image. NEVER CANCEL. Set timeout to 10+ minutes.
- Check MongoDB status: `docker ps` (should show mongodb container running)

### OAuth Configuration
- **REQUIRED**: Create `oauth.js` file in root directory (this file is gitignored)
- Minimal test configuration:
```javascript
module.exports = {
    twitter: {
        consumerKey: 'test_consumer_key',
        consumerSecret: 'test_consumer_secret', 
        callbackURL: 'http://localhost:1337/auth/twitter/callback'
    }
};
```
- For production: Obtain real Twitter API credentials from Twitter Developer Portal

### Running the Application
- **INCOMPATIBILITY WARNING**: Original `npm start` fails with modern Node.js due to `app.configure()` deprecation
- **Working solution**: Modernize Express middleware setup by replacing deprecated patterns:
  - Remove `app.configure()` blocks
  - Install separate middleware packages: `morgan`, `cookie-parser`, `body-parser`, `method-override`, `express-session`, `errorhandler`
  - Update middleware initialization for Express 4.x compatibility
- Start application: `npm start` or `node app.js` (after modernization)
- Application runs on port 1337: `http://localhost:1337`

### Testing and Validation
- **No test suite**: Application has no defined test scripts (`npm test` returns "No test script defined")
- **Manual validation required**: Always test complete authentication flow:
  1. Navigate to `http://localhost:1337` - should show "Login via Twitter" link
  2. Test `/users` endpoint: `curl http://localhost:1337/users` - should return "respond with a resource"  
  3. Test `/account` redirect: `curl -i http://localhost:1337/account` - should redirect to "/"
- **SCENARIO VALIDATION**: After any changes, verify the login page loads and redirects work correctly

## Validation
- **ALWAYS manually test** the application after making changes by starting the server and checking endpoints
- No automated linting or testing infrastructure exists
- Dependencies have 19 known vulnerabilities (4 low, 4 moderate, 5 high, 6 critical) - this is expected for this legacy codebase
- Jade template engine is deprecated (renamed to Pug) but still functional

## Common Tasks

### Repository Structure
```
.
├── README.md
├── LICENSE  
├── app.js (main application file)
├── package.json
├── oauth.js (gitignored - must create manually)
├── public/
│   └── stylesheets/
│       └── style.css
├── routes/
│   ├── index.js
│   └── user.js
└── views/
    ├── account.jade
    ├── index.jade
    ├── layout.jade
    └── login.jade
```

### Key Files
- `app.js`: Main Express application with Twitter OAuth setup
- `package.json`: Dependencies include Express 4.17.1, Jade, Mongoose, Passport
- `routes/user.js`: Simple user endpoint returning placeholder text
- `views/*.jade`: Jade templates for login, account, and layout

### Common Commands
- Clean install: `rm -rf node_modules && npm install` (2 seconds)
- Start MongoDB: `docker run --name mongodb -d -p 27017:27017 mongo:4.4`
- Stop MongoDB: `docker stop mongodb && docker rm mongodb`
- Check app status: `curl -i http://localhost:1337/`

### Dependencies Output
```
readitinfull@0.0.1
├── express@4.17.1
├── jade@1.11.0 (deprecated, use pug)
├── mongoose@*
├── passport@*
├── passport-twitter@*
└── twit@*
```

### Known Issues
- **Express 3.x compatibility**: Code uses deprecated `app.configure()` patterns
- **Security vulnerabilities**: 19 vulnerabilities in dependencies (expected for legacy code)
- **Deprecated packages**: Jade renamed to Pug, various middleware packages deprecated
- **Missing oauth.js**: Required file is gitignored and must be created manually
- **No tests**: No testing infrastructure present

## Critical Timing and Warnings
- **npm install**: 1-2 seconds. NEVER CANCEL.
- **Docker MongoDB setup**: 2-3 minutes for image pull. NEVER CANCEL. Set timeout to 10+ minutes.
- **Application startup**: Immediate after modernization, fails immediately with original code.
- **NEVER CANCEL** any Docker or npm operations - they complete quickly but may appear to hang.

The application represents a Twitter-based authentication system that requires modernization for current Node.js environments but demonstrates working OAuth patterns once properly configured.