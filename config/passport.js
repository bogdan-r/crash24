var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var bcrypt = require('bcrypt-nodejs');

passport.serializeUser(function(user, done){
    done(null, user[0].id);
});

passport.deserializeUser(function(id, done){
    User.findById(id).exec(function(err, user){
        done(err, user);
    })
});

passport.use(new LocalStrategy(function(username, password, done){
    User.findByUsername(username).exec(function(err, user){
        if(err){return done(nullerr)}
        if(!user || user.length > 1){
            return done(null, false, {message : 'Incorrect user'});
        }
        bcrypt.compare(password, user[0].password, function(err, res){
            if(!res){
                return done(null, false, {message : 'Invalid password'});
            }
            return done(null, user);
        });
    });
}));

module.exports = {
    express : {
        customMiddleware: function(app){
            app.use(passport.initialize());
            app.use(passport.session());
        }
    }
};