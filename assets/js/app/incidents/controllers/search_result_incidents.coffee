angular.module(IncidentsMControllers).controller('IncidentSearchResultCtrl', [
  '$scope'
  'Incident'
  ($scope, Incident)->
    #var


    #scope
    _.extend($scope, {
      incidents : []
      isOpen : false
    })

    #helpers

    #event handler
    $scope.$on('$stateChangeSuccess', (e, toState, toParam, fromState, fromParam)->
      #FIXME сделать вариант понадежнее
      if fromState.name == 'search.result.showitem'
        $scope.isOpen = false
    )

    #run
    Incident.search((incidents)->
      $scope.incidents = incidents
    )
])