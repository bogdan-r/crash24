angular.module(UserControllers).controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  'Incident'
  ($scope, $state, Incident)->

    #var

    #scope
    _.extend($scope, {
      addIncident : (incidentParam)->
        incident = new Incident(incidentParam)
        incident.$save().then(
          (incident)->
            $state.go('account.incidents')
        , (err)->
          console.log(err)
        )
    })

    #helpers

    #event handler

    #run

])