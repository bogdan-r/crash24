angular.module('app.components').factory('LocateDefinition', [
  '$rootScope'
  ($rootScope)->

    class LoacteDefinition
      isExistLocate : ->
        if localStorage.getItem('isFirstVisit') == 'true' || localStorage.getItem('isFirstVisit') == true
          return true
        else
          return false

      setExistLocate : ->
        localStorage.setItem('isFirstVisit', true)

      setCity : (city)->
        cityGeoParam = {
          name : city.properties.get('name')
          coord : city.geometry.getCoordinates()
          boundedBy : city.properties.get('boundedBy')
        }
        localStorage.setItem('currentCityInfo', JSON.stringify(cityGeoParam))
        return

      getCityInfo : ()->
        JSON.parse(localStorage.getItem('currentCityInfo'))


    new LoacteDefinition()
])