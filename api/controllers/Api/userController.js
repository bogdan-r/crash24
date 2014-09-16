/**
 * Api/userController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

module.exports = {
    create : function(req, res){
        var errors = new ErrorStorage();
        var userParam = {
            username : req.param('username'),
            email : req.param('email'),
            password : req.param('password')
        }
        User.create(userParam).exec(function(err, user){
            if(err){
                var transformsErrors = errors.transformValidateErrors(err)
                return res.badRequest(transformsErrors)
            }
            req.logIn(user, function(err){
                return res.json(user.toJSON());
            })
        })
    },
    profile : function(req, res){
        if(!req.user){
            return res.serverError();
        }else{
            User.findOne(req.user.id).exec(function(err, user){
                if(err){return res.serverError();}
                return res.json(user)
            })
        }
    }
};
