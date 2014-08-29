angular.module('app.modules.search.controllers').controller('MapMainCtrl', [
  '$scope',
  '$state',
  'LocateDefinition'
  'Incident'
  ($scope, $state, LocateDefinition, Incident)->

    #var
    _map = null
    _points = []
    _cityInfo = LocateDefinition.getCityInfo()

    #scope
    _.extend($scope, {
      points : []
      cityCoords : _cityInfo.coord

      afterMapInit : (map)->
        _map = map

      chouseIncident : ($event, point)->
        $state.go('search.result.showitem', {id : point.incident.id})
    })

    #helpers

    #event handler
    $scope.$on('chouseSearchPlace', (e, place)->
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
    )

    $scope.$on('loadIncidentItem', (e, incident)->
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