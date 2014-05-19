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
            lat : req.param('lat'),
            long : req.param('long'),
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

        Incident.update({id : idIncident, user : req.user.id}, incidentParams).exec(function(err, incident){
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
    //TODO для теста, обязательно удалить
	find : function(req, res){
        Incident.find().exec(function(err, incidents){
            res.json(incidents)
        })
    },
    show : function(req, res){
        Incident.findOne({id : req.param('id')}).exec(function(err, incident){
            if(err){return res.badRequest()}
            if(!incident){return res.notFound()}

            return res.json(incident)
        })
    },
    search : function(req, res){

    }

};
