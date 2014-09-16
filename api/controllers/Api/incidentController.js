/**
 * Api/incidentController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

var url = require('url');
var http = require('http');
var fs = require('node-fs');

module.exports = {

    create : function(req, res){
        var socialVideo = new SocialVideo(req.param('video'));
        var socialVideoInfo = socialVideo.getVideoInfo();
        var errors = new ErrorStorage();

        if(socialVideoInfo.videoType === undefined){
            errors.add('video', 'Ссылка на видео не верна')
        }
        if(req.param('lat') === undefined || req.param('long') === undefined){
            errors.add('place', 'Не удалось определить место проишествие, укажите место на карте')
        }
        if(errors.hasError()){
            return res.badRequest(errors.get())
        }

        var incidentParams = {
            title :       req.param('title'),
            video :       socialVideoInfo.embedUrl,
            video_type :  socialVideoInfo.videoType,
            original_video_url : req.param('video'),
            lat :         parseFloat(req.param('lat')),
            long :        parseFloat(req.param('long')),
            date :        req.param('date'),
            description : req.param('description'),
            place :       req.param('place'),
            boundedBy :   req.param('boundedBy'),
            user :        req.user.id
        };

        Incident.create(incidentParams).exec(function(err, incident){
            if (err) return res.badRequest();
            socialVideo.setVideoThumbs(incident).then(function(){
                return res.json(incident);
            }, function(errProm){
                return res.badRequest();
            });

        })

    },
    findByAccount : function(req, res){
        Incident.findByActiveState({user : req.user.id}).exec(function(err, incidents){
            if(err){return res.badRequest()}
            res.json(incidents)
        })
    },
    showByAccount : function(req, res){
        Incident.findOne({
            id : req.param('id'),
            user : req.user.id
        }).exec(function(err, incident){
                if(err){return res.badRequest()}
                res.json(incident)
            });
    },
    show : function(req, res){
        Incident.findByActiveState({id : req.param('id')}).exec(function(err, incident){
            if(err){return res.badRequest()}
            if(!incident.length){return res.notFound()}

            return res.json(incident[0])
        })
    },
    update : function(req, res){
        var idIncident = req.param('id');
        var socialVideo = new SocialVideo(req.param('video'));
        var socialVideoInfo = socialVideo.getVideoInfo();
        var errors = new ErrorStorage();

        if(socialVideoInfo.videoType === undefined){
            errors.add('video', 'Ссылка на видео не верна')
        }
        if(req.param('lat') === undefined || req.param('long') === undefined){
            errors.add('place', 'Не удалось определить место проишествие, укажите место на карте')
        }
        if(errors.hasError()){
            return res.badRequest(errors.get())
        }

        var incidentParams = {
            title :       req.param('title'),
            video :       socialVideoInfo.embedUrl,
            video_type :  socialVideoInfo.videoType,
            original_video_url : req.param('video'),
            lat :         parseFloat(req.param('lat')),
            long :        parseFloat(req.param('long')),
            date :        req.param('date'),
            description : req.param('description'),
            place :       req.param('place'),
            boundedBy :   req.param('boundedBy'),
            user :        req.user.id
        };

        Incident.update({
            id: idIncident,
            user: req.user.id
        }, incidentParams).exec(function (err, incident) {
            if (err) return res.badRequest();
            socialVideo.setVideoThumbs(incident[0]).then(function () {
                return res.json(incident[0]);
            }, function (errProm) {
                return res.badRequest();
            });

        })

    },
    delete : function(req, res){
        Incident.remove({
            id: req.param('id'),
            user: req.user.id
        }).exec(function (err, incident) {
                if (err) {return res.serverError()}
                return res.json(incident[0])
            });
    },
    restore : function(req, res){
        Incident.restore({
            id: req.param('id'),
            user: req.user.id
        }).exec(function (err, incident) {
                if (err) {return res.serverError()}
                return res.json(incident[0])
            });
    },

    search : function(req, res){
        //TODO Переписать на поиск с условиями

        var orderBy =  req.param('order_by') || 'distance';
        var skip =     parseInt(req.param('skip'));
        var take =     parseInt(req.param('take'));
        var distance = parseInt(req.param('distance'))
        var location = {
            lat : req.param('lat'),
            long : req.param('long')
        }
        if(!req.param('lat') || !req.param('long') || isNaN(take)){
            return res.badRequest()
        }
        var incidents = Incident.findByActiveState();
        switch (orderBy){
            case 'distance':
            default :
                incidents.then(function(incidents){
                    var sortResult = sortByDistance(incidents, location);
                    sortResult = sortResult.splice(isNaN(skip) ? 0 : skip, take);
                    return res.json(sortResult)
                }).fail(function(err){
                    if (err) {return res.badRequest()}
                })
                break
            case 'date':
                incidents.sort('date ASC').exec(function(err, incidents){
                    if (err) {return res.badRequest()}
                    return res.json(incidents)
                });
                break
        }


    },

    searchMap : function(req, res){
        //TODO Переписать на поиск с условиями для карты
        Incident.findByActiveState().exec(function(err, incidents){
            if (err) {return res.badRequest()}
            return res.json(incidents)
        })
    }
};
