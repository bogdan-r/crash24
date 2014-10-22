angular.module('app.modules.user.controllers').controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  '$timeout'
  'SettingsServ'
  'LocateDefinition'
  'Incident'
  'AccountIncidentCollection'
  ($scope, $state, $timeout, SettingsServ, LocateDefinition, Incident, AccountIncidentCollection)->

    #var
    _map = null
    _locatePlaceInfo = LocateDefinition.getCityInfo()
    _settings = new SettingsServ

    #scope
    _.extend($scope, {
      datepickerSetting : _settings.get('datePickers:addIncident')
      errors : {}

      placeAutocompliteList : [] #Массив с адресами геолокации

      incidentParam : {} #Параметры для добавления инцидента
      currentCityCenter : [_locatePlaceInfo.coord[0], _locatePlaceInfo.coord[1]]

      afterMapInit : (map)->
        _map = map
        _map.setBounds(_locatePlaceInfo.boundedBy)
        return

      setIncidentCoordsHandler : ($event)->
        coords = $event.get('coords')
        _setIncidentCoords(coords)

      addIncident : (incidentParam)->
        AccountIncidentCollection.add(incidentParam).then(()->
          $state.go('account.incidents')
        , (err)->
          $scope.errors = err.data.errors
        )

      resetError : (error)->
        $scope.errors[error] = []

      #Поиск списка адресов по строке
      relatedAddress : (value)->
        ymaps.geocode(incidentForm.place.value, {
          results : 10
          boundedBy : _locatePlaceInfo.boundedBy
        }).then((result)->
          interimArr = []
          result.geoObjects.each((el)->
            props = el.properties.getAll()
            interimArr.push("#{props.name} #{props.description}")
          )
          return interimArr
        )

      findAddressByValue : ($item)->
        ymaps.geocode($item, {
          results : 1
          boundedBy : _locatePlaceInfo.boundedBy
        }).then((result)->
          geoObject = result.geoObjects.get(0)
          coords = geoObject.geometry.getCoordinates()
          _chousePlace({
            prop : geoObject.properties.getAll()
            coords : coords
          })
          $scope.$apply()
        )

      dragIncidentMarker : ($event)->
        _setIncidentCoords($event.get('target').geometry.getCoordinates())

    })

    #helpers

    #TODO вынести работу с данными в отдельную компоненту
    _setValuesPlaceFields = (geoObjProp)->
      $scope.incidentParam.place = "#{geoObjProp.name} #{geoObjProp.description}"

    _chousePlace = (place)->
      _setValuesPlaceFields(place.prop)
      $scope.incidentParam.lat = place.coords[0]
      $scope.incidentParam.long = place.coords[1]
      $scope.incidentParam.boundedBy = place.prop.boundedBy
      $scope.incidentPoint = {
        geometry: {
          type: 'Point'
          coordinates: [place.coords[0], place.coords[1]]
        }
      }
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
      $scope.placeAutocompliteList = []

    _setIncidentCoords = (coords)->
      $scope.incidentParam.lat = coords[0]
      $scope.incidentParam.long = coords[1]
      $scope.incidentPoint = {
        geometry: {
          type: 'Point'
          coordinates: [coords[0], coords[1]]
        }
      }
      ymaps.geocode(coords, {
        results : 1
      }).then((result)->
        geoObject = result.geoObjects.get(0)
        properties = geoObject.properties.getAll()
        $scope.incidentParam.boundedBy = geoObject.properties.getAll().boundedBy
        _setValuesPlaceFields(properties)
        $scope.$apply()
      )


    #event handler

    #run
    AccountIncidentCollection.getAll()

])