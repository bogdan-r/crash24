/**
 * Api/userController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

var path = require('path')
var fs = require('node-fs');
module.exports = {
    create : function(req, res){
        var errors = new ErrorStorage();
        var userParam = {
            username : req.param('username'),
            email : req.param('email'),
            password : req.param('password'),
            confirm_password : req.param('confirm_password')
        }
        if(userParam.password !== userParam.confirm_password){
            errors.add('confirm_password', 'Пароли не совпадают');
            errors.add('password', 'Пароли не совпадают');
            return res.badRequest(errors.get())
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
        if(!req.user){return res.serverError()}
        User.findOne(req.user.id).exec(function(err, user){
            if(err){return res.serverError();}
            return res.json(user)
        })
    },
    update : function(req, res){
        //TODO обработать ошибку
        if(!req.user){return res.serverError()}
        var errors = new ErrorStorage();
        var userParam = {
            id : req.user.id,
            username : req.param('username'),
            email : req.param('email'),
            name : req.param('name')
        }

        User.update(req.user.id, userParam).exec(function(err, user){
            if (err) {
                var transformsErrors = errors.transformValidateErrors(err)
                return res.badRequest(transformsErrors)
            };
            return res.json(user[0]);
        })
    },
    updatePassword : function(req, res){
        //TODO обработать ошибку
        if(!req.user){return res.serverError()}
        var errors = new ErrorStorage();
        var userParam = {
            old_password : req.param('old_password'),
            new_password : req.param('new_password'),
            new_password_confirm : req.param('new_password_confirm')
        }

        User.findOne(req.user.id).exec(function(err, user){
            if (err) {return res.serverError()};
            var isValidPass = user.validPassword(userParam.old_password)

            if(!isValidPass){
                errors.add('old_password', 'Неправильный пароль');
                return res.badRequest(errors.get())
            }
            if(userParam.new_password !== userParam.new_password_confirm){
                errors.add('new_password', 'Пароли не совпадают');
                errors.add('new_password_confirm', 'Пароли не совпадают');
                return res.badRequest(errors.get())
            }

            user.password = userParam.new_password;
            user.save()

            return res.json(user)
        })

    },
    uploadAvatar : function(req, res){
        //TODO обработать ошибку
        if(!req.user){return res.serverError()}

        var errors = new ErrorStorage();
        var avatarUrl = UserAvatar.getAvatarsUrl().avatarUrlAsset + req.user.id + '/';
        var avatarOriginName = UserAvatar.getOriginalAvatarName();
        req.file('avatar').upload({
            dirname : avatarUrl,
            saveAs : function(file){
                return avatarOriginName + path.extname(file.filename)
            },
            maxBytes : 1000000
        }, function(err, files){
            if (err){
                errors.add('avatar', 'Ошибка при загрузке файла');
                return res.badRequest(errors.get())
            }
            var avatarOriginUrl = avatarUrl + avatarOriginName + path.extname(files[0].filename);
            var userAvatar = new UserAvatar({
                originalAvatar : avatarOriginUrl
            });
            userAvatar.generateAvatars().then(function(){
                    User.update(req.user.id, {id : req.user.id, isSetAvatar : true}).exec(function(err, user){
                        return res.json({avatars : UserAvatar.getAvatarUrlPublic(req.user.id)});
                    });
                }).fail(function (err) {
                    fs.unlink(avatarOriginUrl, function () {})
                    errors.add('avatar', 'Ошибка при загрузке файла');
                    return res.badRequest(errors.get())
                });
        });

    }
};
