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
                res.json(422, {errors : {
                    common : "Произошла ошибка"
                }})
            }
            req.logIn(user, function(err){
                if(err){
                    res.json(422, {errors : {
                        password : "Email или пароль введен неверно"
                    }})
                }
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
