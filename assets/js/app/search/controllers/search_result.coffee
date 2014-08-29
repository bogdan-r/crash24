angular.module('app.modules.search.controllers').controller('IncidentSearchResultCtrl', [
  '$rootScope'
  '$scope'
  'Incident'
  'LocateDefinition'
  ($rootScope, $scope, Incident, LocateDefinition)->
    #var
    cityInfo = LocateDefinition.getCityInfo()

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
    $scope.$on('chouseSearchPlace', (e, place)->
      Incident.search({lat : place.coords[0], long : place.coords[1]}, (incidents)->
        $scope.incidents = incidents
      )
    )

    #run
    Incident.search({lat : cityInfo.coord[0], long : cityInfo.coord[1]}, (incidents)->
      $scope.incidents = incidents
    )
])