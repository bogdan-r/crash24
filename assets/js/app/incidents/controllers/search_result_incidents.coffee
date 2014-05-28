angular.module(IncidentsMControllers).controller('IncidentSearchResultCtrl', [
  '$scope'
  'Incident'
  ($scope, Incident)->
    #var
    console.log('IncidentSearchResultCtrl')
    #scope
    _.extend($scope, {
      incidents : []
    })

    #helpers

    #event handler

    #run
    Incident.search((incidents)->
      $scope.incidents = incidents
    )
])