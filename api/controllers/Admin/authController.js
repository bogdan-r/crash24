/**
 * Admin/authController
 *
 * @description :: Server-side logic for managing admin/auths
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
    new : function(req, res){
        return res.view();
    },

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

    logout: function (req, res) {
        req.logout();
        res.redirect('/admin/session/new')
    }
};

