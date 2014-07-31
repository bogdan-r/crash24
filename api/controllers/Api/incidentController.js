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
        //TODO после перехода на mysql сделать валидацию на загрузку миниатюры
        var videoUrl = url.parse(req.param('video'), true);
        var formattedVideoUrl;
        var videoType;
        var videoThumbnailUrl; //http://img.youtube.com/vi/i9MHigUZKEM/default.jpg
        var videoBigThumbnailUrl; //http://img.youtube.com/vi/i9MHigUZKEM/0.jpg

        if(videoUrl.host && videoUrl.host.search(/youtube/) && videoUrl.query.v){
            formattedVideoUrl = '//www.youtube.com/embed/' + videoUrl.query.v
            videoType = 'youtube'
            videoThumbnailUrl = 'http://img.youtube.com/vi/' + videoUrl.query.v + '/default.jpg'
            videoBigThumbnailUrl = 'http://img.youtube.com/vi/' + videoUrl.query.v + '/0.jpg'
        }else{
            return res.badRequest({error : 'Ссылка на видео не верна'})
        }

        var incidentParams = {
            title : req.param('title'),
            video : formattedVideoUrl,
            video_type : videoType,
            lat : parseFloat(req.param('lat')),
            long : parseFloat(req.param('long')),
            date : req.param('date'),
            description : req.param('description'),
            place : req.param('place'),
            user : req.user.id
        };

        async.waterfall([
            function (cb) {
                Incident.create(incidentParams).exec(cb)
            },
            function (incident, cb) {

                function getThumbRequest (thumbUrl, asyncCb){
                    http.get(thumbUrl, function (response) {
                        var imageData = '';

                        response.setEncoding('binary');
                        response.on('data', function (chunk) {
                            imageData += chunk;
                        })
                        response.on('end', function () {
                            asyncCb(null, imageData);
                        })

                    }).on('error', function(){
                            asyncCb(null, imageData);
                        });
                }

                async.parallel({
                    thumb : function(innerCb){
                        getThumbRequest(videoThumbnailUrl, innerCb);
                    },
                    thumb_big : function(innerCb){
                        getThumbRequest(videoBigThumbnailUrl, innerCb);
                    }
                }, function(err, imagesData){
                    cb(err, incident, imagesData)
                });

            },
            function(incident, imagesData, cb){
                fs.mkdir(incident.urlToThumbAssets(), 0777, true, function(err){
                    cb(null, incident, imagesData);
                })

            },
            function(incident, imagesData, cb){

                function writeThumb (url, imgData, asyncCb){
                    fs.writeFile(url, imgData, 'binary', function (err) {
                        asyncCb(null);
                    })
                }
                async.parallel([
                    function(innerCb){
                        writeThumb(incident.urlThumbAssets(), imagesData.thumb, innerCb);
                    },
                    function(innerCb){
                        writeThumb(incident.urlBigThumbAssets(), imagesData.thumb_big, innerCb);
                    }
                ], function(err){
                    cb(null, incident);
                })

            }

        ], function(err, incident){
            //TODO сделать обработку ошибок
            if (err) return res.badRequest();
            return res.json(incident);
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
                res.json(incident)
            });
    },
    show : function(req, res){
        Incident.findByActiveState({id : req.param('id')}).exec(function(err, incident){
            if(err){return res.badRequest()}
            if(!incident){return res.notFound()}

            return res.json(incident[0])
        })
    },
    update : function(req, res){
        var idIncident = req.param('id');
        var incidentParams = {
            title : req.param('title'),
            lat : req.param('lat'),
            long : req.param('long'),
            date : req.param('date'),
            description : req.param('description'),
            place : req.param('place')
        };

        Incident.update({
            id : idIncident,
            user : req.user.id
        }, incidentParams).exec(function(err, incident){
            if(err){return res.badRequest()}
            return res.json(incident);
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


    search : function(req, res){
        //TODO Переписать на поиск с условиями
        Incident.findByActiveState().exec(function(err, incidents){
            if (err) {return res.badRequest()}
            return res.json(incidents)
        })
    },

    searchMap : function(req, res){
        //TODO Переписать на поиск с условиями для карты
        Incident.findByActiveState().exec(function(err, incidents){
            if (err) {return res.badRequest()}
            return res.json(incidents)
        })
    }
};
