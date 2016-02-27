angular.module('app.modules.user.controllers').controller('AccountIncidentsShowCtrl', [
  '$scope'
  '$stateParams'
  '$sce'
  'AccountIncidentCollection'
  ($scope, $stateParams, $sce, AccountIncidentCollection)->

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
    AccountIncidentCollection.get($stateParams.id).then((incident)->
      $scope.incident = incident
    )
])