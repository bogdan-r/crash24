angular.module('app.modules.search.controllers').controller('IncidentShowFromResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  '$sce'
  '$q'
  '$location'
  '$timeout'
  'Incident'
  'mapApiLoad'
  'CurrentPlaceStorage'
  ($rootScope, $scope, $state, $stateParams, $sce, $q, $location, $timeout, Incident, mapApiLoad, CurrentPlaceStorage)->
    #var
    _deferIncident = $q.defer()

    #scope
    _.extend($scope, {
      incident : {}
      trustVideoSrc : (src)->
        $sce.trustAsResourceUrl(src)

      goToSearch : ->
        $rootScope.$broadcast('closeIncidentItem', $scope.incident)
        $state.go('search.result', CurrentPlaceStorage.getPlaceParams())

    })

    #helpers

    #event handler
    $scope.$on('$stateChangeSuccess', (e, toState, toParam, fromState, fromParam)->
      if fromState.name.indexOf('search') == -1
        _deferIncident.promise.then((incident)->
          CurrentPlaceStorage.set('lat', incident.lat)
          CurrentPlaceStorage.set('long', incident.long)
          CurrentPlaceStorage.set('place', incident.place)
          CurrentPlaceStorage.set('boundLocation', incident.boundedBy)
          $rootScope.$broadcast('firstLoadIncidentItem', incident)
        )
    )
    #run
    Incident.get({id : $stateParams.id}, (incident)->
      $scope.incident = incident
      mapApiLoad(()->
        $rootScope.$broadcast('loadIncidentItem', incident)
      )
      _deferIncident.resolve(incident)
    )
])