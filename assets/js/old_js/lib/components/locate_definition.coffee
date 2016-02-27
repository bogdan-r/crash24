angular.module('app.components').factory('LocateDefinition', [
  '$rootScope'
  ($rootScope)->

    class LoacteDefinition
      DEFAULT_GEO_PARAM = {"country":"Россия","name":"Москва","coord":[55.753676,37.619899],"boundedBy":[[55.490631,37.298509],[55.957565,37.967682]]}
      isExistLocate : ->
        if localStorage.getItem('isFirstVisit') == 'true' || localStorage.getItem('isFirstVisit') == true
          return true
        else
          return false

      setExistLocate : ->
        localStorage.setItem('isFirstVisit', true)

      setCity : (city)->

        cityGeoParam = {
          country_id : city.properties.get('country_id')
          country : city.properties.get('metaDataProperty.GeocoderMetaData.AddressDetails.Country.CountryName')
          name : city.properties.get('name')
          coord : city.geometry.getCoordinates()
          boundedBy : city.properties.get('boundedBy')
        }
        localStorage.setItem('currentCityInfo', JSON.stringify(cityGeoParam))
        return

      setDefault : ()->
        localStorage.setItem('currentCityInfo', JSON.stringify(DEFAULT_GEO_PARAM))

      getCityInfo : ()->
        JSON.parse(localStorage.getItem('currentCityInfo'))


    new LoacteDefinition()
])