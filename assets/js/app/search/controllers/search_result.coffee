angular.module('app.modules.search.controllers').controller('IncidentSearchResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  '$cacheFactory'
  'SettingsServ'
  'Incident'
  'LocateDefinition'
  'CurrentPlaceStorage'
  ($rootScope, $scope, $state, $stateParams, $cacheFactory, SettingsServ, Incident, LocateDefinition, CurrentPlaceStorage)->
    #var
    _cityInfo = LocateDefinition.getCityInfo()
    _cityInfoOptions = {}

    _settings = new SettingsServ
    _sortFilters = _settings.get('sortFilters')

    _incidentCount = 0
    _incidentScrollElement = null

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
      currentScrollOffset : _settings.get('caches:searchResultScroll')

      scrollOffset : (e, offset)->
        $scope.currentScrollOffset.put('offset', offset)

      scrollOffsetInit : ($element)->
        _incidentScrollElement = $element
        return

      renderIncident : (index)->
        _incidentCount = _incidentCount + index + 1
        if _incidentCount == $scope.locationIncidents.length + $scope.userLocationIncidents.length + $scope.otherIncidents.length
          _setScrollOffset()
    })
    #helpers

    _setScrollOffset = ()->
      if !_.isNull(_incidentScrollElement)
        offset = $scope.currentScrollOffset.get('offset')
        if offset
          _incidentScrollElement.scrollTop(offset)
          $scope.currentScrollOffset.put('offset', 0)


    #event handler
    $scope.$on('chouseSearchPlace', ()->
      $scope.currentScrollOffset.put('offset', 0)
      _incidentScrollElement.scrollTop(0)
    )
    $scope.$on('changeSearchFilter', ()->
      $scope.currentScrollOffset.put('offset', 0)
      _incidentScrollElement.scrollTop(0)
    )

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
      CurrentPlaceStorage.set(_.extend({}, _cityInfoOptions, {
        dateFrom : $stateParams.dateFrom
        dateTo : $stateParams.dateTo
      }))

    if $stateParams.orderBy
      $scope.predicate = _sortFilters[$stateParams.orderBy].predicate
      $scope.reverse = _sortFilters[$stateParams.orderBy].reverse

    $scope.place = CurrentPlaceStorage.get('place')
    #NOTE обычная загрузка проишествий
    Incident.search(_.extend({}, CurrentPlaceStorage.getPlaceParams(), {
        boundUserCity : _cityInfo.boundedBy
        take : 100}), (incidents)->
      $scope.locationIncidents = incidents.groupByLocation
      $scope.userLocationIncidents = incidents.groupByUserLocation
      $scope.otherIncidents = incidents.groupByOther
    )
])