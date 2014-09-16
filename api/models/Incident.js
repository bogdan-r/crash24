/**
* Incident.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {
    attributes: {
        title: {
            type : 'string',
            required : true
        },
        lat : {type : 'float'},
        long : {type : 'float'},
        boundedBy : {type : 'array'},
        date : {
            type : 'date',
            required : true
        },
        description : {type : 'text'},
        place : {type : 'string'},
        video : {type : 'string'},
        video_type : {type : 'string'},
        original_video_url : {type : 'string'},
        isApproved : {
            type : 'boolean',
            defaultsTo : false
        },
        isActive : {
            type : 'boolean',
            defaultsTo : true
        },
        user : {model : 'user'},

        toJSON : function(){
            var publicThumbAsset = SocialVideo.getThumbsUrl().thumbUrlAssetPublic;
            var thumbsName = SocialVideo.getThumbsName();
            var obj = this.toObject();
            if(typeof obj.boundedBy == 'string'){
                obj.boundedBy = JSON.parse(obj.boundedBy)
            }
            delete obj.isApproved;
            delete obj.isActive;
            delete obj.user;
            obj.video_thumbnail = publicThumbAsset + this.id + '/' + thumbsName.original;
            obj.video_thumbnail_small = publicThumbAsset + this.id + '/' + thumbsName.small;

            return obj;
        }

    },
    //Поиск по активным событиям
    findByActiveState : function(options){
        var extParams = null;
        if(_.isObject(options) && !_.isEmpty(options)){
            extParams = _.extend(options, {
                isActive : true
            });
        }else{
            extParams = {isActive : true};
        }
        return Incident.find(extParams)
    },
    //Удаление событий, их скрытие
    remove : function(options){
        return Incident.update(options, {isActive : false})
    },
    //Востановление событий, их скрытие
    restore : function(options){
        return Incident.update(options, {isActive : true})
    }
};

