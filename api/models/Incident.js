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
        video : {
            type : 'string'
        },
        video_type : {
            type : 'string'
        },
        //TODO после перехода на mySql, сделать валидацию для миниатюры к видео
        video_thumbnail : {
            type : 'string',
            defaultsTo : 'thumb.jpg'
        },
        video_thumbnail_big : {
            type : 'string',
            defaultsTo : 'thumb_big.jpg'
        },
        isApproved : {
            type : 'boolean',
            defaultsTo : false
        },
        isActive : {
            type : 'boolean',
            defaultsTo : true
        },
        user : {
            model : 'user'
        },
        urlToThumbAssets : function(){
            return 'assets/images/uploads/Incident/thumb/' + this.id
        },
        urlThumbAssets : function(){
            return 'assets/images/uploads/Incident/thumb/' + this.id + '/' + this.video_thumbnail
        },
        urlThumbForResult : function(){
            return '/images/uploads/Incident/thumb/' + this.id + '/' + this.video_thumbnail
        },

        urlBigThumbAssets : function(){
            return 'assets/images/uploads/Incident/thumb/' + this.id + '/' + this.video_thumbnail_big
        },
        urlBigThumbForResult : function(){
            return '/images/uploads/Incident/thumb/' + this.id + '/' + this.video_thumbnail_big
        },
        toJSON : function(){
            var obj = this.toObject();
            delete obj.isActive;
            delete obj.user;
            obj.video_thumbnail = this.urlThumbForResult();
            obj.video_thumbnail_big = this.urlBigThumbForResult();

            return obj;
        }

    },
    //Поиск по активным событиям
    findByActiveState : function(options){
        var extParams = null;
        if(_.isObject(options) && _.isEmpty(options)){
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
    }
};

