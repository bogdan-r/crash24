angular.module('app.modules.search.controllers').controller('IncidentSearchResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  'SettingsServ'
  'Incident'
  'LocateDefinition'
  'CurrentPlaceStorage'
  ($rootScope, $scope, $state, $stateParams, SettingsServ, Incident, LocateDefinition, CurrentPlaceStorage)->
    #var
    _cityInfo = LocateDefinition.getCityInfo()
    _cityInfoOptions = {}

    _settings = new SettingsServ
    _sortFilters = _settings.get('sortFilters')

    #scope
    _.extend($scope, {
      predicate : ''
      reverse : false
      #TODO сделать коллекцию, для избавления от лишних запросов
      locationIncidents : []
      userLocationIncidents : []
      otherIncidents : []
      cb : new Date().getTime()
      cityInfo : _cityInfo
      place : ''
    })
    #helpers

    #event handler

    #run

    if !CurrentPlaceStorage.isSetPlaceParams()
      if $stateParams.lat && $stateParams.long && $stateParams.place && $stateParams.boundLocation
        boundLocation = $stateParams.boundLocation.split(',')
        boundLocation = [[boundLocation[0], boundLocation[1]], [boundLocation[2], boundLocation[3]]]
        _cityInfoOptions = {
          lat : $stateParams.lat
          long : $stateParams.long
          place : $stateParams.place
          boundLocation : boundLocation
        }
      else
        _cityInfoOptions = {
          lat : _cityInfo.coord[0]
          long : _cityInfo.coord[1]
          place : _cityInfo.name
          boundLocation : _cityInfo.boundedBy
        }
      CurrentPlaceStorage.set(_cityInfoOptions)

    if $stateParams.orderBy
      $scope.predicate = _sortFilters[$stateParams.orderBy].predicate
      $scope.reverse = _sortFilters[$stateParams.orderBy].reverse

    $scope.place = CurrentPlaceStorage.get('place')
    #NOTE обычная загрузка проишествий
    Incident.search({
        lat : CurrentPlaceStorage.get('lat')
        long : CurrentPlaceStorage.get('long')
        boundLocation : CurrentPlaceStorage.get('boundLocation')
        boundUserCity : _cityInfo.boundedBy
        dateFrom : $stateParams.dateFrom
        dateTo : $stateParams.dateTo
        take : 100}, (incidents)->
      $scope.locationIncidents = incidents.groupByLocation
      $scope.userLocationIncidents = incidents.groupByUserLocation
      $scope.otherIncidents = incidents.groupByOther
    )
])