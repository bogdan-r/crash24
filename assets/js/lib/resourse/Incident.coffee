angular.module('app.resources').factory('Incident', [
  '$resource'
  ($resource)->
    Incident = $resource('/api/incident/:id', null, {
      'findByAccount' : {
        method : 'GET'
        url : '/api/account/incident'
        isArray : true
      },
      search : {
        method : 'POST'
        url : '/api/incident/search'
        isArray : true
      },
      searchMap : {
        method : 'POST'
        url : '/api/incident/searchmap'
        isArray : true
      }
    })

    Incident
])