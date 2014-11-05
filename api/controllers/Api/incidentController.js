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
        var errors = new ErrorStorage();
        var reqParams = req.allParams();
        reqParams = _.extend(reqParams, {user : req.user.id});
        var incidentParamsProvider = IncidentParamsProvider.retrieve(reqParams);


        if(incidentParamsProvider.errors !== undefined){
            return res.badRequest(incidentParamsProvider.errors)
        }

        Incident.create(incidentParamsProvider.incidentParams).exec(function(err, incident){
            if (err){
                var transformsErrors = errors.transformValidateErrors(err)
                return res.badRequest(transformsErrors)
            }
            incidentParamsProvider.socialVideo.setVideoThumbs(incident).then(function(){
                return res.json(incident);
            }, function(errProm){
                //TODO сделать откат записи
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
        var reqParams = req.allParams();
        reqParams = _.extend(reqParams, {user : req.user.id});
        var incidentParamsProvider = IncidentParamsProvider.retrieve(reqParams);

        if(incidentParamsProvider.errors !== undefined){
            return res.badRequest(incidentParamsProvider.errors)
        }

        Incident.update({
            id: idIncident,
            user: req.user.id
        }, incidentParamsProvider.incidentParams).exec(function (err, incident) {
            if (err) return res.badRequest();
            incidentParamsProvider.socialVideo.setVideoThumbs(incident[0]).then(function () {
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
        var reqParams = req.allParams();
        var incidentContentProvider = new IncidentContentProvider(reqParams);

        incidentContentProvider.retrieveIncident().then(function(results){
            return res.json(results)
        }).fail(function(){
                return res.badRequest()
            })

    },

    searchMap : function(req, res){
        var reqParams = req.allParams();
        var incidentContentProvider = new IncidentContentProvider(reqParams);

        incidentContentProvider.retrieveMapIncident().then(function(results){
            return res.json(results)
        }).fail(function(){
                return res.badRequest()
            })
    }
};
