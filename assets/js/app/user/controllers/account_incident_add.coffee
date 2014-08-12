angular.module('app.modules.user.controllers').controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  '$timeout'
  'LocateDefinition'
  'Incident'
  'AccountIncidentCollection'
  ($scope, $state, $timeout, LocateDefinition, Incident, AccountIncidentCollection)->

    #var
    _map = null
    _adressAutocompliteTimeout = null
    _locatePlaceInfo = LocateDefinition.getCityInfo()

    #scope
    _.extend($scope, {
      placeAutocompliteList : [] #Массив с адресами геолокации
      countriesAutocompliteList : []
      cityAutocompliteList : []
      streetAutocompliteList : []

      openedCalendar : false
      isExtendSearch : false
      incidentParam : {} #Параметры для добавления инцидента
      currentCityCenter : [_locatePlaceInfo.coord[0], _locatePlaceInfo.coord[1]]

      #Флаги всплывающих попапов
      statusDrodown : {
        isOpenPlace : false
        isOpenCountry : false
        isOpenCity : false
        isOpenStreet : false
      }

      #Параметры с полями для расширенного поиска
      extFormField : {
        country : _locatePlaceInfo.country
        city : _locatePlaceInfo.name
        street : ''
      }

      openCalendar : ()->
        $scope.openedCalendar = true

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
          #TODO обработать ошибки
          console.log(err)
        )

      #Поиск списка адресов по строке
      relatedAddress : ($event)->
        $timeout.cancel(_adressAutocompliteTimeout)
        _adressAutocompliteTimeout = $timeout(()->
          ymaps.geocode(incidentForm.place.value, {
            results : 10
            boundedBy : _locatePlaceInfo.boundedBy
          }).then((result)->
            interimArr = []
            result.geoObjects.each((el)->
              interimArr.push({
                prop : el.properties.getAll()
                coords : el.geometry.getCoordinates()
              })
            )
            $scope.placeAutocompliteList = interimArr
            if _isEnptyListDropdown('placeAutocompliteList')
              _hideDropdowns('isOpenPlace')
            else
              _showDropdowns('isOpenPlace')
            $scope.$apply()
          )
        , 500)
        if $event.target.value == ''
          _hideDropdowns('isOpenPlace')
          $scope.placeAutocompliteList = []

      findAddressByValue : ()->
        ymaps.geocode(incidentForm.place.value, {
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

      chousePlaceHandler : ($event, place)->
        _chousePlace(place)

      showDropdownsHandler : ($event, dropdownPlaylist, dropdown)->
        _showDropdownsHandler($event, dropdownPlaylist, dropdown)

      hideDropdownsHandler : ($event, dropdown)->
        _hideDropdownsHandler($event, dropdown)

      dragIncidentMarker : ($event)->
        _setIncidentCoords($event.get('target').geometry.getCoordinates())

      showExtendSearch : ->
        $scope.isExtendSearch = true

      hideExtendSearch : ->
        $scope.isExtendSearch = false

    })

    #helpers

    _isEnptyListDropdown = (dropdownList)->
      !$scope[dropdownList].length

    _showDropdowns = (dropdown)->
      $scope.statusDrodown[dropdown] = true

    _hideDropdowns = (dropdown)->
      $scope.statusDrodown[dropdown] = false

    _showDropdownsHandler = (e, dropdownPlaylist, dropdown)->
      e.preventDefault()
      e.stopPropagation()
      if !_isEnptyListDropdown(dropdownPlaylist)
        _showDropdowns(dropdown)

    _hideDropdownsHandler = (e, dropdown)->
      e.preventDefault()
      e.stopPropagation()
      $timeout(()->
        _hideDropdowns(dropdown)
      , 200)

    _setValuesPlaceFields = (geoObjProp)->
      $scope.incidentParam.place = "#{geoObjProp.name} #{geoObjProp.description}"

    _chousePlace = (place)->
      _setValuesPlaceFields(place.prop)
      $scope.incidentParam.lat = place.coords[0]
      $scope.incidentParam.long = place.coords[1]
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
        _setValuesPlaceFields(geoObject.properties.getAll())
        $scope.$apply()
      )


    #event handler

    #run

])