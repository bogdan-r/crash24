angular.module('app.modules.search.controllers').controller('IncidentSearchFiltersCtrl',[
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  '$timeout'
  'SettingsServ'
  'LocateDefinition'
  'CurrentPlaceStorage'
  'filtersNameServ'
  ($rootScope, $scope, $state, $stateParams, $timeout, SettingsServ, LocateDefinition, CurrentPlaceStorage, filtersNameServ)->

    #var
    _cityInfo = LocateDefinition.getCityInfo()
    _adressAutocompliteTimeout = null
    _settings = new SettingsServ
    _sortFilters = _settings.get('sortFilters')

    #scope
    _.extend($scope, {
      isOpenFilterPanel : false
      placeAutocompliteList : [] #Массив с адресами геолокации
      statusDrodown : {
        isOpenPlace : false
      }
      currentLocation : _cityInfo.name
      sortFilters : _sortFilters
      filters : {
        dateFrom : null
        dateTo : null
      }
      datepickerSetting : _settings.get('datePickers:searchFilter')
      filtersNamesList : []

      relatedAddress : ($event)->
        $timeout.cancel(_adressAutocompliteTimeout)
        _adressAutocompliteTimeout = $timeout(()->
          ymaps.geocode($scope.currentLocation, {
            results : 5
            boundedBy : _cityInfo.boundedBy
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

      toggleFilterPanel : ($event)->
        $scope.isOpenFilterPanel = !$scope.isOpenFilterPanel

      showDropdownsHandler : ($event, dropdownPlaylist, dropdown)->
        _showDropdownsHandler($event, dropdownPlaylist, dropdown)

      hideDropdownsHandler : ($event, dropdown)->
        _hideDropdownsHandler($event, dropdown)

      chousePlaceHandler : ($event, place)->
        $scope.currentLocation = "#{place.prop.text}"
        CurrentPlaceStorage.set('lat', place.coords[0])
        CurrentPlaceStorage.set('long', place.coords[1])
        CurrentPlaceStorage.set('place', place.prop.text)
        CurrentPlaceStorage.set('boundLocation', place.prop.boundedBy)
        $rootScope.$broadcast('chouseSearchPlace', place)
        $state.go('search.result', CurrentPlaceStorage.getPlaceParams())
        $scope.placeAutocompliteList = []

      applyFilters : ()->
        $scope.setFiltersNamesList()
        _goToSearchResult()

      resetFilters : ()->
        $scope.filters = {
          dateFrom : null
          dateTo : null
          orderBy : _sortFilters[0]
        }
        $scope.setFiltersNamesList()
        _goToSearchResult()

      setFiltersNamesList : ()->
        $scope.filtersNamesList = filtersNameServ.getFiltersNamesList($scope.filters)
    })

    #helpers
    #TODO копипаста из добавления видео, вынести в отдельную компоненту
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

    _goToSearchResult = ()->
      $state.go('search.result', _.extend({}, $scope.filters, {orderBy : $scope.filters.orderBy.value}))


    #event handler
    $scope.$on('firstLoadIncidentItem', (e, incident)->
      $scope.currentLocation = incident.place
    )

    #run
    if $stateParams.place
      $scope.currentLocation = _.pick($stateParams, 'place').place

    $scope.filters = _.pick($stateParams, 'dateFrom', 'dateTo')
    if $stateParams.orderBy
      $scope.filters.orderBy = _sortFilters[$stateParams.orderBy]
    else
      $scope.filters.orderBy = _sortFilters[0]

    $scope.setFiltersNamesList()
])
