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
        var errors = new ErrorStorage();
        passport.authenticate('local',{badRequestMessage: 'Неверный пароль или email'}, function(err, user, info){
            if(err || !user){
                errors.add('common', info.message)
                return res.badRequest(errors.get())
            }
            req.logIn(user, function(err){
                if(err){
                    errors.add('common', "Неверный пароль или email")
                    return res.badRequest(errors.get())
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
