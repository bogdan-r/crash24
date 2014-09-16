angular.module('app.modules.user.controllers').controller('AccountIncidentsCtrl', [
  '$scope'
  '$filter'
  'AccountIncidentCollection'
  ($scope, $filter, AccountIncidentCollection)->

    #var

    #scope
    _.extend($scope, {
      incidents : []
      cb : new Date().getTime()

      deleteIncident : ($event, incident)->
        AccountIncidentCollection.delete(incident.id).then(()->
          $scope.incidents = $filter('splitApart')(AccountIncidentCollection.getAll(true), [3])
        )
    })
    #helpers

    #event handler

    #run
    AccountIncidentCollection.getAll().then((incidents)->
      $scope.incidents = $filter('splitApart')(incidents, [3])
    )
])