angular.module('app.modules.user.controllers').controller('AccountIncidentsCtrl', [
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
    Incident.findByAccount((incidents)->
      $scope.incidents = incidents
    )
])