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
app.configure(function () {
    app.set('port', process.env.PORT || 1337);
    app.set('views', path.join(__dirname, 'views'));
    app.set('view engine', 'jade');

    //app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.json());
    app.use(express.urlencoded());
    app.use(express.methodOverride());
    app.use(express.static(path.join(__dirname, 'public')));
    app.use(express.cookieParser());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.session({
        secret: 'my_precious'
    }));

    app.use(passport.initialize());
    app.use(passport.session());

    app.use(app.router);
});

app.configure('development', function () {
    // development only
    app.use(express.errorHandler());
});


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
