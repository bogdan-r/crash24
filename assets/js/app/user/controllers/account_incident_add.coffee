angular.module(UserControllers).controller('AccountIncidentsAddCtrl', [
  '$scope'
  '$state'
  'Incident'
  ($scope, $state, Incident)->

    #var
    _map = null

    #scope
    _.extend($scope, {
      afterMapInit : (map)->
        _map = map

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