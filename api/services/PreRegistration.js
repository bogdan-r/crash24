var passwordGenerator = require('password-generator');
var crypto = require('crypto');
var q = require('q');

var PreRegistration = {};

PreRegistration.register = function(params){
    params = params || {}
    var defer = q.defer()
    var userParams = {
        username : params.username || '',
        email : params.email || '',
        password : passwordGenerator(10, false)
    };
    userParams.verificationToken = crypto.createHash('md5').update(sails.config.salt + userParams.username + userParams.email).digest('hex');

    User.create(_.extend({}, userParams)).exec(function(err, user){
        if(err){
            defer.reject(err)
        }else{
            var port = parseInt(sails.config.port) === 80 ? '' : ':' + sails.config.port
            Email.send({
                to : [{
                    name : user.username,
                    email : user.email
                }],
                subject : 'Регистрация на allcrash.ru',
                html :
                    'Вы зарегестрировались на сайте allcrash.ru <br>' +
                    'Ваш пароль: ' + userParams.password + '<br>' +
                    'Для полноценного использования сайта, вам нужно подтвердить регистрацию ' +
                    '<a href="http://allcrash.ru'+ port +'/user/verification?token=' + userParams.verificationToken + '">http://allcrach.ru'+ port +'/user/verification?token=' + userParams.verificationToken + '</a>'
            });
            defer.resolve(user)
        }

    })

    return defer.promise

}

module.exports = PreRegistration