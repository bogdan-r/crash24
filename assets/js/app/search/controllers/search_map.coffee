angular.module('app.modules.search.controllers').controller('MapMainCtrl', [
  '$scope',
  '$state',
  '$stateParams',
  'LocateDefinition',
  'mapApiLoad'
  'Incident',
  ($scope, $state, $stateParams, LocateDefinition, mapApiLoad, Incident)->

    #var
    _map = null
    _points = []
    _cityInfo = LocateDefinition.getCityInfo()

    if $stateParams.lat && $stateParams.long
      _cityCoords = [$stateParams.lat, $stateParams.long]
    else
      _cityCoords = _cityInfo.coord

    #scope
    _.extend($scope, {
      points : []
      cityCoords : _cityCoords

      afterMapInit : (map)->
        _map = map

      chouseIncident : ($event, point)->
        isStateShowItem = $state.current.name == 'search.showitem'
        isStateShowItemFromMap = $state.current.name == 'search.showitem.fromMap'
        if (isStateShowItem or isStateShowItemFromMap) and parseInt($stateParams.id) == parseInt(point.incident.id)
          $state.go('search.result')
        else
          $state.go('search.showitem.fromMap', {id : point.incident.id}, {})
    })

    #helpers

    #event handler
    $scope.$on('chouseSearchPlace', (e, place)->
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
    )

    $scope.$on('loadIncidentItem', (e, incident)->
      if $state.current.data?.fromMap == false or $state.current.data?.fromMap == undefined
        _map.setCenter([incident.lat, incident.long], 15, {
          checkZoomRange : true
        })
    )

    #run
    Incident.searchMap((incidents)->
      for incident, i in incidents
        _points.push({
          incident : incident
          geometry: {
            type: 'Point'
            coordinates: [incident.lat, incident.long]
          }
        })

      $scope.points = _points
    )

])