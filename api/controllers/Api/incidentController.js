/**
 * Api/incidentController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

module.exports = {

    create : function(req, res){
        var incidentParams = {
            title : req.param('title'),
            lat : parseFloat(req.param('lat')),
            long : parseFloat(req.param('long')),
            date : req.param('date'),
            description : req.param('description'),
            place : req.param('place'),
            user : req.user.id
        };

        Incident.create(incidentParams).exec(function(err, incident){
            if(err){return res.badRequest()}
            return res.json(incident);
        })
    },
    findByAccount : function(req, res){
        Incident.find({user : req.user.id}).exec(function(err, incidents){
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
        Incident.findOne({id : req.param('id')}).exec(function(err, incident){
            if(err){return res.badRequest()}
            if(!incident){return res.notFound()}

            return res.json(incident)
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
        Incident.find({
            id: req.param('id'),
            user: req.user.id
        }).exec(function (err, incident) {
                if (err) {return res.badRequest()}
                incident.destroy(function(err){
                    if(err){return res.badRequest()}
                    return res.json(incident)
                })
            });
    },


    search : function(req, res){
        //TODO Переписать на поиск с условиями
        Incident.find().exec(function(err, incidents){
            if (err) {return res.badRequest()}
            return res.json(incidents)
        })
    },

    searchMap : function(req, res){
        //TODO Переписать на поиск с условиями для карты
        Incident.find().exec(function(err, incidents){
            if (err) {return res.badRequest()}
            return res.json(incidents)
        })
    }
};
