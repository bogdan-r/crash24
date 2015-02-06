/**
 * Api/messageController.js
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

var q = require('q');
module.exports = {
    create : function(req, res){
        var errors = new ErrorStorage();
        var messageParams = {
            text : req.param('text'),
            userRecipient : req.param('userRecipient'),
            incident : req.param('incidentId')
        }
        var userParams = {
            username : req.param('username'),
            email : req.param('email')
        }

        var isWrongUserRecipientVal = _.isUndefined(messageParams.userRecipient)
            && _.isNull(messageParams.userRecipient)
            && _.isEmpty(messageParams.userRecipient)
        var isWrongIncidentVal = _.isUndefined(messageParams.incident)
            && _.isNull(messageParams.incident)
            && _.isEmpty(messageParams.incident)
        if(isWrongUserRecipientVal || isWrongIncidentVal){
            errors.add('common', 'Неправильные данные')
            return res.badRequest(errors.get())
        }


        Incident.find({id : messageParams.incident, user : messageParams.userRecipient}).then(function(incident){
            if(incident.length === 0){
                errors.add('common', 'У данного пользователя нет такого видео');
                throw new Error();
            }

            if(req.isAuthenticated()){
                messageParams.user = req.user.id;
                var defer = q.defer();
                defer.resolve();
                return defer.promise
            }else{
                return PreRegistration.register(userParams);
            }

        }).then(function(user){
            if(user){
                messageParams.user = user.id;
            }

            if(parseInt(messageParams.user) == parseInt(messageParams.userRecipient)){
                errors.add('common', 'Нельзя отправить сообщение себе');
                throw new Error();
            }
            return Message.create(messageParams)

        }).then(function(message){
            return [message, User.findOne(messageParams.userRecipient)]

        }).spread(function(message, userRecipient){
            Email.send({
                to : [{
                    name : userRecipient.username,
                    email : userRecipient.email
                }],
                subject : 'Новое сообщение',
                text : 'Вы получили новое сообщение, для прочтения войдите в личный кабинет'
            }, function(err){
                console.log(err)
            });

            return res.json(message)
        }).fail(function(err){
            var transformsErrors = errors.transformValidateErrors(err);
            res.badRequest(transformsErrors)
        })
    }
};
