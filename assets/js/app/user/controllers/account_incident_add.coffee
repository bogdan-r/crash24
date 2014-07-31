angular.module('app.modules.user.controllers').controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  '$timeout'
  'LocateDefinition'
  'Incident'
  'LocateInfo'
  ($scope, $state, $timeout, LocateDefinition, Incident, LocateInfo)->

    #TODO рефакторинг, слишком много копипасты

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
        #TODO поменять функцию добавления на сервис
        incident = new Incident(incidentParam)
        incident.$save().then(
          (incident)->
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


      ###
      #Поиск релевантной страны(расширенный поиск)
      relatedCountry : ($event)->
        $timeout.cancel(_adressAutocompliteTimeout)
        if $event.target.value == ''
          _hideDropdowns('isOpenCountry')
          $scope.countriesAutocompliteList = []
          $scope.extFormField.city = ''
          $scope.extFormField.street = ''
          return
        _adressAutocompliteTimeout = $timeout(()->
          LocateInfo.findCountryByName({title : $event.target.value}, (countries)->
            $scope.countriesAutocompliteList = countries
            if _isEnptyListDropdown('countriesAutocompliteList')
              _hideDropdowns('isOpenCountry')
            else
              _showDropdowns('isOpenCountry')
          )
        , 200)


      #Поиск релевантного города(расширенный поиск)
      relatedCity : ($event)->
        $timeout.cancel(_adressAutocompliteTimeout)
        if $event.target.value == ''
          _hideDropdowns('isOpenCity')
          $scope.extFormField.street = ''
          return
        _adressAutocompliteTimeout = $timeout(()->
          LocateInfo.findCityByName({
            title : $event.target.value
            country_id :  $scope.extFormField.country.id
          }, (cities)->
            $scope.cityAutocompliteList = cities
            if _isEnptyListDropdown('cityAutocompliteList')
              _hideDropdowns('isOpenCity')
            else
              _showDropdowns('isOpenCity')
          )
        , 200)

      #Поиск релевантной улицы(расширенный поиск)
      relatedStreet : ()->
        $timeout.cancel(_adressAutocompliteTimeout)
        _adressAutocompliteTimeout = $timeout(()->
          ymaps.geocode("#{incidentForm.street.value}, #{incidentForm.city.value}, #{incidentForm.country.value}", {
            results : 10
          }).then((result)->
            interimArr = []
            result.geoObjects.each((el)->
              interimArr.push({
                prop : el.properties.getAll()
                coords : el.geometry.getCoordinates()
              })
            )
            $scope.streetAutocompliteList = interimArr
            if _isEnptyListDropdown('streetAutocompliteList')
              _hideDropdowns('isOpenStreet')
            else
              _showDropdowns('isOpenStreet')
            $scope.$apply()
          )
        , 500)
      ###
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

      ###
      setCountryItem : ($event, country)->
        if !country
          return
        $scope.extFormField.country = {
          id : country.country_id
          name : country.title_ru
        }
        $scope.countriesAutocompliteList = []
        _hideDropdowns('isOpenCountry')

      setCityItem : ($event, city)->
        if !city
          return
        $scope.extFormField.city = city.title_ru
        $scope.cityAutocompliteList = []
        _hideDropdowns('isOpenCity')
      ###

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