angular.module(Resources).factory('Incident', [
  '$resource'
  ($resource)->
    Incident = $resource('/api/incident/:incidentId')

    Incident
])