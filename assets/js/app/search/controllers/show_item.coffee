angular.module('app.modules.search.controllers').controller('IncidentShowFromResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  '$sce'
  'Incident'
  'mapApiLoad'
  ($rootScope, $scope, $state, $stateParams, $sce, Incident, mapApiLoad)->
    #var

    #scope
    _.extend($scope, {
      incident : {}
      trustVideoSrc : (src)->
        $sce.trustAsResourceUrl(src)
    })

    #helpers

    #event handler

    #run
    Incident.get({id : $stateParams.id}, (incident)->
      $scope.incident = incident
      mapApiLoad(()->
        $rootScope.$broadcast('loadIncidentItem', incident)
      )
    )
    $scope.$parent.isOpen = true
])