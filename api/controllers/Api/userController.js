/**
 * Api/userController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

module.exports = {
    create : function(req, res){
        User.create(req.body).exec(function(err, user){
            if(err){
                //TODO Написать нормальные обработчик ошибок, удалить все лишнее
                return res.json(err.status, err);
            }
            return res.json(user.toJSON());
        })
    },
    profile : function(req, res){
        if(!req.user){
            return res.serverError();
        }else{
            return res.json(req.user)
        }
    }
};
