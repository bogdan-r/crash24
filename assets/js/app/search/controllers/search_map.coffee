angular.module('app.modules.search.controllers').controller('MapMainCtrl', [
  '$scope',
  '$state',
  '$stateParams',
  '$q'
  'LocateDefinition',
  'CurrentPlaceStorage'
  'mapApiLoad'
  'templateLayoutFactory'
  'Incident',
  ($scope, $state, $stateParams, $q, LocateDefinition, CurrentPlaceStorage, mapApiLoad, templateLayoutFactory, Incident)->

    #var
    _deferMap = $q.defer()
    _deferPoint = $q.defer()
    _map = null
    _points = []
    _cityInfo = LocateDefinition.getCityInfo()
    _activeIncidentIndex = null

    if $stateParams.lat && $stateParams.long
      _cityCoords = [$stateParams.lat, $stateParams.long]
    else
      _cityCoords = _cityInfo.coord

    #scope
    _.extend($scope, {
      points : []
      cityCoords : _cityCoords

      mapsItemOptions : {
        iconLayout : 'incidentItemLayout',
        iconShape : {
          type : 'Rectangle',
          coordinates: [[-37, -56], [37, 0]]
        }
        hideIconOnBalloonOpen : false
      }

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
    })

    #helpers
    _pointsIndexOf = (itemId)->
      index = -1
      _.any $scope.points, (x, i) ->
        if x.incident.id == itemId
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
      _deferPoint.promise.then(->
        if _activeIncidentIndex != null
          _resetActivePoint()
        _activeIncidentIndex = _pointsIndexOf(incident.id)
        $scope.points[_activeIncidentIndex].properties.isActive = true
      )

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

    #run
    Incident.searchMap((incidents)->
      for incident, i in incidents
        _points.push({
          incident : incident
          geometry: {
            type: 'Point'
            coordinates: [incident.lat, incident.long]
          },
          properties : {
            incident : incident
            isActive : false
          }
        })

      $scope.points = _points
      _deferPoint.resolve(_points)
    )

])