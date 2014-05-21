/**
* Incident.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

    attributes: {
        title: {
            type: 'string',
            required: true
        },
        lat : {
            type : 'float'
        },
        long : {
            type : 'float'
        },
        date : {
            type : 'date',
            required: true
        },
        description : {
            type : 'text'
        },
        place : {
            type : 'string'
        },
        user : {
            model : 'user'
        },
        toJSON : function(){
            var obj = this.toObject();
            delete obj.user;

            return obj;
        }

    }
};

