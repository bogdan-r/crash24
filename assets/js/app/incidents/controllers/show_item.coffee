angular.module(IncidentsMControllers).controller('IncidentShowFromResultCtrl', [
  '$scope'
  '$stateParams'
  'Incident'
  ($scope, $stateParams, Incident)->
    #var

    #scope
    _.extend($scope, {
      incident : {}
    })

    #helpers

    #event handler

    #run
    Incident.get({id : $stateParams.id}, (incident)->
      $scope.incident = incident
    )
    $scope.$parent.isOpen = true
])