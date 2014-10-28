angular.module('app.modules.search.controllers').controller('MapMainCtrl', [
  '$scope',
  '$state',
  '$stateParams',
  '$q'
  '$timeout'
  'LocateDefinition',
  'CurrentPlaceStorage'
  'mapApiLoad'
  'templateLayoutFactory'
  'Incident'
  'SettingsServ'
  'MapPointCollection'
  ($scope, $state, $stateParams, $q, $timeout, LocateDefinition, CurrentPlaceStorage, mapApiLoad, templateLayoutFactory, Incident, SettingsServ, MapPointCollection)->

    #var
    _deferMap = $q.defer()
    _deferPoint = $q.defer()
    _map = null
    _mapPointCollection = MapPointCollection
    _points = []
    _cityInfo = LocateDefinition.getCityInfo()
    _settings = new SettingsServ
    _activeIncidentIndex = null


    if $stateParams.lat && $stateParams.long
      _cityCoords = [$stateParams.lat, $stateParams.long]
    else
      _cityCoords = _cityInfo.coord

    #scope
    _.extend($scope, {
      points : []
      cityCoords : _cityCoords

      mapsItemOptions : _settings.get('mapsItemOptions')

      afterMapInit : (map)->
        _map = map
        _deferMap.resolve(map)

      chouseIncident : ($event, point)->
        isStateShowItem = $state.current.name == 'search.showitem'
        isStateShowItemFromMap = $state.current.name == 'search.showitem.fromMap'
        if (isStateShowItem or isStateShowItemFromMap) and parseInt($stateParams.id) == parseInt(point.incident.id)
          _resetActivePoint()
          $state.go('search.result', CurrentPlaceStorage.getPlaceParams())
        else
          $state.go('search.showitem.fromMap', {id : point.incident.id}, {})

      itemMouseenter : ($event)->
        iconContentLayout = templateLayoutFactory.get('incidentItemHoverLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      itemMouseleave : ($event)->
        if $event.get('target').properties.get('isActive')
          return
        iconContentLayout = templateLayoutFactory.get('incidentItemLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      itemPropChange : ($event, point)->
        isActive = $event.get('target').properties.get('isActive')
        if isActive
          iconContentLayout = templateLayoutFactory.get('incidentItemActiveLayout')
        else
          iconContentLayout = templateLayoutFactory.get('incidentItemLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      moveMap : ($event)->
        _mapPointCollection.load({
          dateFrom : $stateParams.dateFrom
          dateTo : $stateParams.dateTo
          boundMap : _map.getBounds()
        }).then((points)->
          $scope.points = points
          console.info 'load moveMap'
        )

    })

    #helpers
    _pointsIndexOf = (itemId)->
      index = -1
      _.any $scope.points, (x, i) ->
        if x.incident.id == parseInt(itemId)
          index = i
          return true
      index

    _resetActivePoint = (index)->
      pointIndex = if index then index else _activeIncidentIndex
      $scope.points[pointIndex].properties.isActive = false
      _activeIncidentIndex = null

    #event handler
    $scope.$on('chouseSearchPlace', (e, place)->
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
    )

    $scope.$on('loadIncidentItem', (e, incident)->
      console.info 'loadIncidentItem'
      _deferPoint = $q.defer()
      _deferPoint.resolve(incident)
#      _deferPoint.promise.then(()->
#      $timeout(->

      ###if _activeIncidentIndex != null
        _resetActivePoint()
      _activeIncidentIndex = _pointsIndexOf(incident.id)
      $scope.points[_activeIncidentIndex].properties.isActive = true###

#      , 1000)

#      )

      if $state.current.data?.fromMap == false or $state.current.data?.fromMap == undefined
        _deferMap.promise.then(->
          _map.setCenter([incident.lat, incident.long], 15, {
            checkZoomRange : true
          })
        )

      return
    )

    $scope.$on('closeIncidentItem', (e, incident)->
      _resetActivePoint(_pointsIndexOf(incident.id))
    )

    $scope.$on('changeSearchFilter', (e)->
      console.log('changeSearchFilter')
      if $state.current.name == 'search.showitem'
        _resetActivePoint(_pointsIndexOf($state.params.id))

      _mapPointCollection.load({
        dateFrom : $stateParams.dateFrom
        dateTo : $stateParams.dateTo
        boundMap : _map.getBounds()
      }, true).then((points)->
        $scope.points = points
      )
    )


    #run

    _deferMap.promise.then(->
      _mapPointCollection.load({
        dateFrom : $stateParams.dateFrom
        dateTo : $stateParams.dateTo
        boundMap : _map.getBounds()
      }).then((points)->
        $scope.points = points
      )
    )

])