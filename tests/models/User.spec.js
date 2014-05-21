var User = require('../../api/models/User');
var assert = require('assert');

describe('User model', function(){
    describe('Перед тем как создать юзера', function(){
        it ('пароль должен быть зашифрован', function(done){
            User.beforeCreate({
                password: 'password'
            }, function(err, user){
                assert.notEqual(user.password, 'password');
                done();
            })
        })
    })
})