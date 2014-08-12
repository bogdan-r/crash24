/**
* Users.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

var bcrypt = require('bcrypt-nodejs');

function hashPassword(values, next){
    bcrypt.hash(values.password, null, null, function(err, hash){
        if(err){
            next(err);
        }
        values.password = hash;
        next(null, values);
    })
}
module.exports = {

    attributes: {
        username :{
            type : 'string',
            required: true,
            unique : true
        },
        email : {
            type : 'email',
            required : true,
            unique : true
        },
        password : {
            type : 'string',
            required : true
        },
        incidents : {
            collection: 'incident',
            via: 'user'
        },
        admin : {
            type : 'boolean',
            defaultsTo : false
        },
        toJSON : function(){
            var obj = this.toObject();
            delete obj.password;
            delete obj.admin;
            return obj;
        },
        validPassword : function(password, callback){
            var obj = this.toObject();
            if(callback){
                return bcrypt.compare(password, obj.password, callback)
            }
            return bcrypt.compare(password, obj.password)
        }
    },
    beforeCreate : function(values, next){
        console.log(values);
        hashPassword(values, next);
    },
    beforeUpdate : function(values, next){
        if(values.password){
            hashPassword(values, next);
        }else{
            User.findOne(values.id).exec(function(err, user){
                if(err){
                    next(err);
                }else{
                    values.password = user.password;
                    next();
                }
            })
        }
    }
};

