/**
 * Api/userController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

var path = require('path')
var fs = require('node-fs');
var crypto = require('crypto');
var q = require('q')
module.exports = {
    create : function(req, res){
        var errors = new ErrorStorage();
        var userParams = {
            username : req.param('username'),
            email : req.param('email'),
            password : req.param('password'),
            confirm_password : req.param('confirm_password')
        }
        //TODO Вынести верификацию в отдельный сервис
        userParams.verificationToken = crypto.createHash('md5').update(sails.config.salt + userParams.username + userParams.email).digest('hex')
        if(userParams.password !== userParams.confirm_password){
            errors.add('confirm_password', 'Пароли не совпадают');
            errors.add('password', 'Пароли не совпадают');
            return res.badRequest(errors.get())
        }

        User.create(userParams).exec(function(err, user){
            if(err){
                var transformsErrors = errors.transformValidateErrors(err)
                return res.badRequest(transformsErrors)
            }
            //TODO Вынести отправку подтверждения в отдельный сервис
            var port = parseInt(sails.config.port) === 80 ? '' : ':' + sails.config.port
            Email.send({
                to : [{
                    name : user.username,
                    email : user.email
                }],
                subject : 'Подтверждение регистрации',
                html :
                    'Для подтверждения регистрации перейдите по ссылке ' +
                    '<a href="http://allcrash.ru'+ port +'/user/verification?token=' + userParams.verificationToken + '">http://allcrach.ru'+ port +'/user/verification?token=' + userParams.verificationToken + '</a>'

            });

            req.logIn(user, function(err){
                return res.json(user.toJSON());
            })
        })
    },
    profile : function(req, res){
        if(!req.user){return res.serverError()}
        q.fcall(function(){
            var user = User.findOne(req.user.id)
            var messages = Message.find({
                or : [
                    {user: req.user.id},
                    {userRecipient: req.user.id}
                ]
            }).populate('user').populate('userRecipient').populate('incident')
            return [user, messages]
        }).spread(function(user, messages){
                user.messages = messages
                for(var i = 0; i < user.messages.length; i++){
                    user.messages[i].user = UserHelpers.convertUserToSafe(user.messages[i].user.toJSON())
                    user.messages[i].userRecipient = UserHelpers.convertUserToSafe(user.messages[i].userRecipient.toJSON())

                    if (user.messages[i].user.id == user.id){user.messages[i].isSentMessage = true}
                    user.messages[i].incident = user.messages[i].incident.toJSON()
                    delete user.messages[i].incident.messages
                }
                return res.json(user)
            }).fail(function(err){
                if(err){return res.serverError();}
            })
    },
    update : function(req, res){
        //TODO обработать ошибку
        if(!req.user){return res.serverError()}
        var errors = new ErrorStorage();
        var userParams = {
            id : req.user.id,
            username : req.param('username'),
            email : req.param('email'),
            name : req.param('name')
        }

        User.update(req.user.id, userParams).exec(function(err, user){
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
        var userParams = {
            old_password : req.param('old_password'),
            new_password : req.param('new_password'),
            new_password_confirm : req.param('new_password_confirm')
        }

        User.findOne(req.user.id).exec(function(err, user){
            if (err) {return res.serverError()};
            var isValidPass = user.validPassword(userParams.old_password)

            if(!isValidPass){
                errors.add('old_password', 'Неправильный пароль');
                return res.badRequest(errors.get())
            }
            if(userParams.new_password !== userParams.new_password_confirm){
                errors.add('new_password', 'Пароли не совпадают');
                errors.add('new_password_confirm', 'Пароли не совпадают');
                return res.badRequest(errors.get())
            }

            user.password = userParams.new_password;
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

    },
    verification : function(req, res){
        var errors = new ErrorStorage();
        var verificationParams = {
            verificationToken : req.param('token'),
            email : req.param('email')
        }
        User.findOne(verificationParams).exec(function(err, user){
            if (err || _.isUndefined(user)) {
                errors.add('common', 'Данный пользователь не найден')
                return res.badRequest(errors.get())
            }

            user.isVerification = true
            user.verificationToken = ''
            delete user.password //NOTE что бы не обновлял пароль
            user.save(function(err, u){
                if (err) {
                    errors.add('common', 'Произошла ошибка, попробуйте еще раз')
                    return res.badRequest(errors.get())
                }
                return res.json({})
            })


        })

    },
    getVerificateTokenByEmail : function(req, res){
      var errors = new ErrorStorage();
      User.findOne(req.user.id).exec(function(err, user){
        if (err) {return res.serverError()};

        //TODO Вынести отправку подтверждения в отдельный сервис
        var port = parseInt(sails.config.port) === 80 ? '' : ':' + sails.config.port
        Email.send({
          to : [{
            name : user.username,
            email : user.email
          }],
          subject : 'Подтверждение регистрации',
          html :
            'Вы повторно запросили ссылку для подтверждения регистрации: ' +
              '<a href="http://allcrash.ru'+ port +'/user/verification?token=' + user.verificationToken + '">http://allcrach.ru'+ port +'/user/verification?token=' + user.verificationToken + '</a>'

        });

        return res.json({ok : true})
      })
    }
};
