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
    types : {
        isCurrentUsername : function(username){
            return username.match(/^[a-zA-Z][a-zA-Z0-9-_\.]{1,20}$/) == null ? false : true
        }
    },
    attributes: {
        username :{
            type : 'string',
            required: true,
            unique : true,
            isCurrentUsername : true
        },
        name : {
            type : 'string'
        },
        email : {
            type : 'email',
            required : true,
            unique : true
        },
        isSetAvatar : {
            type : 'boolean',
            defaultsTo : false
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
        sentMessages : {
            collection : 'message',
            via : 'user'
        },
        receivedMessages : {
            collection : 'message',
            via : 'userRecipient'
        },
        toJSON : function(){
            var obj = this.toObject();
            obj.avatars = {}
            delete obj.password;
            delete obj.admin;
            if(this.isSetAvatar){
                obj.avatars = UserAvatar.getAvatarUrlPublic(this.id);
            }
            delete obj.isSetAvatar

            return obj;
        },
        validPassword : function(password, callback){
            var obj = this.toObject();
            if(callback){
                return bcrypt.compare(password, obj.password, callback)
            }
            return bcrypt.compareSync(password, obj.password)
        }
    },
    beforeCreate : function(values, next){
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

