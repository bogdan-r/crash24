angular.module('app.modules.search.controllers').controller('IncidentShowFromResultCtrl', [
  '$scope'
  '$stateParams'
  '$sce'
  'Incident'
  ($scope, $stateParams, $sce, Incident)->
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
    )
    $scope.$parent.isOpen = true
])