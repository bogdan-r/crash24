angular.module(Resources).factory('Incident', [
  '$resource'
  ($resource)->
    Incident = $resource('/api/incident/:incidentId', null, {
      'findByAccount' : {
        method : 'GET'
        url : '/api/account/incident'
        isArray : true
      }
    })

    Incident
])