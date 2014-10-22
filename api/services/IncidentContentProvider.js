var q = require('q');
var moment = require('moment');

function IncidentContentProvider (){

}

IncidentContentProvider.retrieve = function(params){
    var defer = q.defer();
    var query = {};

    var orderBy =  params['order_by'] || 'distance';
    var skip =     parseInt(params['skip']);
    var take =     parseInt(params['take']);
    var distance = parseInt(params['distance'])
    var location = {
        lat : params['lat'],
        long : params['long']
    };
    var dates = {
        dateFrom : moment(params['dateFrom'], 'YYYY-MM-DD'),
        dateTo : moment(params['dateTo'], 'YYYY-MM-DD')
    };

    if(dates.dateFrom.isValid() || dates.dateTo.isValid()){query.date = {}}
    if(dates.dateFrom.isValid()){
        query.date['>='] = dates.dateFrom.format()
    }
    if(dates.dateTo.isValid()){
        query.date['<='] = dates.dateTo.format()
    }

    var boundLocation = params['boundLocation'];
    var boundUserCity = params['boundUserCity'];
    if(!params['lat'] || !params['long'] || isNaN(take)){
        defer.reject();
        return defer.promise

    }
    var incidents = Incident.findByActiveState().where(query);
    switch (orderBy){
        case 'distance':
        default :
            incidents.then(function(incidents){
                var sortResult = IncidentSorts.sortByDistance(incidents, location);
                sortResult = sortResult.splice(isNaN(skip) ? 0 : skip, take);
                sortResult = IncidentSorts.groupByLocation(sortResult, boundLocation, boundUserCity);
                defer.resolve(sortResult)
            }).fail(function(err){
                    if (err) {defer.reject()}
                })
            break
    }

    return defer.promise
}

module.exports = IncidentContentProvider