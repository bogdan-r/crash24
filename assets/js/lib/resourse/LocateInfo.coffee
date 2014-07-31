angular.module('app.resources').factory('LocateInfo', [
  '$resource'
  ($resource)->
    LocateInfo = $resource('', null, {
      findCountryByName : {
        method : 'GET'
        url : '/api/get_country_by_name/:title'
        isArray : true
      }
      findCityByName : {
        method : 'GET'
        url : '/api/get_city_by_name/:title'
        isArray : true
      }
    })
])