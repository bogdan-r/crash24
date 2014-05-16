/**
 * Api/authController.js
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */
var passport = require('passport')
module.exports = {
    /**
     * `Api/authController.login`
     */

    login: function (req, res) {
        passport.authenticate('local', function(err, user, info){
            if(err || !user){
                return res.json(422, info)
            }
            req.logIn(user, function(err){
                if(err){
                    return res.json(422, {errors : {
                        password : "Email или пароль введен неверно"
                    }})
                }
                return res.json({});
            })
        })(req, res);
    },

    /**
     * `Api/authController.logout`
     */

    logout: function (req, res) {
        req.logout();
        res.redirect('/')
    }
};