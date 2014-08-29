angular.module('app.modules.user.controllers').controller('AccountIncidentsCtrl', [
  '$scope'
  '$filter'
  'AccountIncidentCollection'
  ($scope, $filter, AccountIncidentCollection)->

    #var

    #scope
    _.extend($scope, {
      incidents : []
      editIncident : ($event, incident)->
        console.log incident

      deleteIncident : ($event, incident)->
        AccountIncidentCollection.delete(incident.id)
    })
    #helpers

    #event handler

    #run
    AccountIncidentCollection.getAll().then((incidents)->
      $scope.incidents = $filter('splitApart')(incidents, [3])
    )
])