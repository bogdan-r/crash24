var q = require('q');
var moment = require('moment');

function IncidentContentProvider (params){
    this.params = params;
    this.query = {};
    this.orderBy =  params['order_by'] || 'distance';
    this.skip =     parseInt(params['skip']);
    this.take =     parseInt(params['take']);
    this.distance = parseInt(params['distance']);
    this.location = {
        lat : params['lat'],
        long : params['long']
    };
    this.dates = {
        dateFrom : moment(params['dateFrom'], 'YYYY-MM-DD'),
        dateTo : moment(params['dateTo'], 'YYYY-MM-DD')
    };
    this.boundLocation = params['boundLocation'];
    this.boundUserCity = params['boundUserCity'];
}

IncidentContentProvider.prototype.retrieveIncident = function(){
    var self = this;
    var defer = q.defer();
    self.query = {};

    if(!self._isExistLocation() || !self._isExistTake()){
        defer.reject();
        return defer.promise
    }

    self._initQueryDate();

    var incidents = Incident.findByActiveState().where(self.query);

    incidents.then(function(incidents){
        var sortResult = incidents;
        sortResult = IncidentSorts.sortByDistance(sortResult, self.location);
        sortResult = sortResult.splice(isNaN(self.skip) ? 0 : self.skip, self.take);
        sortResult = IncidentSorts.groupByLocation(sortResult, self.boundLocation, self.boundUserCity);

        defer.resolve(sortResult);
    }).fail(function(err){
            if (err) {defer.reject()}
        })

    return defer.promise
}
IncidentContentProvider.prototype.retrieveMapIncident = function(){
    var self = this;
    var defer = q.defer();
    var boundMap = self.params['boundMap'];
    self.query = {};
    self.query.lat = {};
    self.query.long = {};

    if(!_.isArray(boundMap)){
        defer.reject();
        return defer.promise
    }

    self._initQueryDate();

    self.query.lat['>='] = boundMap[0][0];
    self.query.lat['<='] = boundMap[1][0];
    self.query.long['>='] = boundMap[0][1];
    self.query.long['<='] = boundMap[1][1];

    console.log(self.query)

    var incidents = Incident.findByActiveState().where(self.query);

    incidents.then(function(incidents){
        var sortResult = incidents;
        defer.resolve(sortResult);
    }).fail(function(err){
            if (err) {defer.reject()}
        })

    return defer.promise
}

IncidentContentProvider.prototype._isExistLocation = function(){
    var self = this;
    return self.location['lat'] && self.location['long']
}
IncidentContentProvider.prototype._isExistTake = function(){
    var self = this;
    return !isNaN(self.take)
}

IncidentContentProvider.prototype._resetQueryDate = function(){
    var self = this;
    if(self.dates.dateFrom.isValid() || self.dates.dateTo.isValid()){self.query.date = {}}
}
IncidentContentProvider.prototype._setQueryDateFrom = function(){
    var self = this;
    if(self.dates.dateFrom.isValid()){
        self.query.date['>='] = self.dates.dateFrom.format()
    }
}
IncidentContentProvider.prototype._setQueryDateTo = function(){
    var self = this;
    if(self.dates.dateTo.isValid()){
        self.query.date['<='] = self.dates.dateTo.format()
    }
}
IncidentContentProvider.prototype._initQueryDate = function(){
    var self = this;
    self._resetQueryDate();
    self._setQueryDateFrom();
    self._setQueryDateTo();
}

module.exports = IncidentContentProvider