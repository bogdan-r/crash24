angular.module('app.modules.user.controllers').controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  '$timeout'
  'LocateDefinition'
  'Incident'
  ($scope, $state, $timeout, LocateDefinition, Incident)->

    #TODO рефакторинг, слишком много копипасты

    #var
    _map = null
    _adressAutocompliteTimeout = null
    _locatePlaceInfo = LocateDefinition.getCityInfo()

    #scope
    _.extend($scope, {
      placeAutocompliteList : []

      openedCalendar : false
      isExtendSearch : false
      incidentParam : {}
      currentCityCenter : [_locatePlaceInfo.coord[0], _locatePlaceInfo.coord[1]]
      statusDrodown : {
        isOpenPlace : false
        isOpenCountry : false
        isOpenCity : false
        isOpenStreet : false
      }

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
        setIncidentCoords(coords)

      addIncident : (incidentParam)->
        incident = new Incident(incidentParam)
        incident.$save().then(
          (incident)->
            $state.go('account.incidents')
        , (err)->
          #TODO обработать ошибки
          console.log(err)
        )

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
            if isEnptyListDropdown('placeAutocompliteList')
              hideDropdowns('isOpenPlace')
            else
              showDropdowns('isOpenPlace')
            $scope.$apply()
          )
        , 500)

        if $event.target.value == ''
          hideDropdowns('isOpenPlace')
          $scope.placeAutocompliteList = []

      relatedCountry : ($event)->
        if $event.target.value == ''
          extFormField.city = ''
          extFormField.street = ''

      relatedCity : ()->
        if $event.target.value == ''
          extFormField.street = ''

      relatedStreet : ()->


      findAddressByValue : ()->
        ymaps.geocode(incidentForm.place.value, {
          results : 1
          boundedBy : _locatePlaceInfo.boundedBy
        }).then((result)->
          geoObject = result.geoObjects.get(0)
          coords = geoObject.geometry.getCoordinates()
          chousePlace({
            prop : geoObject.properties.getAll()
            coords : coords
          })
          $scope.$apply()
        )

      chousePlaceHandler : ($event, place)->
        chousePlace(place)

      dragIncidentMarker : ($event)->
        setIncidentCoords($event.get('target').geometry.getCoordinates())

      showPlaceListHandler : ($event, dropdownPlaylist, dropdown)->
        showDropdownsHandler($event, dropdownPlaylist, dropdown)

      hidePlaceListHandler : ($event, dropdown)->
        hideDropdownsHandler($event, dropdown)

      showExtendSearch : ->
        $scope.isExtendSearch = true

      hideExtendSearch : ->
        $scope.isExtendSearch = false

    })

    #helpers

    isEnptyListDropdown = (dropdownList)->
      !$scope[dropdownList].length

    showDropdowns = (dropdown)->
      $scope.statusDrodown[dropdown] = true

    hideDropdowns = (dropdown)->
      $scope.statusDrodown[dropdown] = false

    showDropdownsHandler = (e, dropdownPlaylist, dropdown)->
      e.preventDefault()
      e.stopPropagation()
      if !isEnptyListDropdown(dropdownPlaylist)
        showDropdowns(dropdown)

    hideDropdownsHandler = (e, dropdown)->
      e.preventDefault()
      e.stopPropagation()
      $timeout(()->
        hideDropdowns(dropdown)
      , 200)

    setValuesPlaceFields = (geoObjProp)->
      $scope.incidentParam.place = "#{geoObjProp.name} #{geoObjProp.description}"

    chousePlace = (place)->
      setValuesPlaceFields(place.prop)
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

    setIncidentCoords = (coords)->
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
        setValuesPlaceFields(geoObject.properties.getAll())
        $scope.$apply()
      )


    #event handler

    #run

])