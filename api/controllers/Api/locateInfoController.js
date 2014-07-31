/**
 * Api/locateInfoController
 *
 * @description :: Server-side logic for managing api/locateinfoes
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	findCountryByName : function(req, res){
        var countryQuery = {
            title_ru : new RegExp(req.param('title'))
        }
        Country.find(countryQuery).exec(function(err, country){
            if(err){return res.badRequest()}
            return res.json(country);
        })
    },
    findCityByName : function(req, res){
        var reqRarams = {
            title_ru : new RegExp(req.param('title')),
            country_id : parseInt(req.param('country_id'), 10)
        }
        if (!req.param('country_id')){
            delete reqRarams.country_id
        }
        City.find(reqRarams).exec(function(err, city){
            if(err){return res.badRequest()}
            return res.json(city);
        })
    }
};

