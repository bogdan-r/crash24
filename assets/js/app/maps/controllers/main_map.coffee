angular.module(YandexMapsControllers).controller('MapMainCtrl', [
  '$scope',
  'Incident'
  ($scope, Incident)->

    #var
    _map = null
    _points = []

    #scope
    _.extend($scope, {
      points : []

      afterMapInit : (map)->
        _map = map
    })

    #helpers

    #event handler

    #run
    Incident.searchMap((incidents)->
      for incident, i in incidents
        _points.push({
          geometry: {
            type: 'Point'
            coordinates: [incident.lat, incident.long]
          }
          properties: {
            iconContent: incident.title,
            balloonContent: incident.description
          }
        })

      $scope.points = _points
    )

])