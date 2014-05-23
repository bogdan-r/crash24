angular.module(IncidentsMControllers).controller('IncidentSearchResultCtrl', [
  '$scope'
  'Incident'
  ($scope, Incident)->
    #var

    #scope
    _.extend($scope, {
      incidents : []

    })

    #helpers

    #event handler

    #run
    Incident.search((incidents)->
      $scope.incidents = incidents
      console.log($scope.incidents)
    )
])