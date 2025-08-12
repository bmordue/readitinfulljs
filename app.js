/*jslint node: true */
"use strict"; // strict Javascript

// client API keys and secrets
var config = require('./oauth.js');

/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var mongoose = require('mongoose');
var passport = require('passport');
var TwitterStrategy = require('passport-twitter').Strategy;

// serialize and deserialize
passport.serializeUser(function (user, done) {
    done(null, user);
});
passport.deserializeUser(function (obj, done) {
    done(null, obj);
});

// config
passport.use(new TwitterStrategy({
        consumerKey: config.twitter.consumerKey,
        consumerSecret: config.twitter.consumerSecret,
        callbackURL: config.twitter.callbackURL
    },
    function (token, tokenSecret, profile, done) {
        process.nextTick(function () {
            return done(null, profile);
        });

        //  User.findOrCreate({ twitterId: profile.id }, function (err, user) {
        //    return done(err, user);
        // });    }
    }));


var app = express();

// all environments
app.set('port', process.env.PORT || 1337);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// Express 4.x compatible middleware
app.use(express.static(path.join(__dirname, 'public')));

// Basic session setup for Express 4.x
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Simple session mock for basic functionality
app.use(function(req, res, next) {
    req.session = req.session || {};
    next();
});

app.use(passport.initialize());
app.use(passport.session());

// development only - Express 4.x doesn't have errorHandler
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        console.error(err.stack);
        res.status(500).send('Something broke!');
    });
}


http.createServer(app).listen(app.get('port'), function () {
    console.log('Express server listening on port ' + app.get('port'));
});



// util

// test authentication
function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect('/');
}

// routes

//app.get('/ping', routes.ping);
app.get('/users', user.list);

app.get('/account', ensureAuthenticated, function (req, res) {
    res.render('account', {
        user: req.user
    });
});

app.get('/', function (req, res) {
    res.render('login', {
        user: req.user
    });
});

app.get('/auth/twitter',
    passport.authenticate('twitter'), function (req, res) {});

app.get('/auth/twitter/callback',
    passport.authenticate('twitter', {
        failureRedirect: '/login'
    }),
    function (req, res) {
        res.redirect('/account');
    });

app.get('/logout', function (req, res) {
    req.logout();
    res.redirect('/');
});
