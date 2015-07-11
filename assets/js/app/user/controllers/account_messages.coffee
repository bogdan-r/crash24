angular.module('app.modules.user.controllers').controller('AccountMessagesCtrl', [
  '$scope'
  '$state'
  'messagesByIncident'
  ($scope, $state, messagesByIncident)->

    #var

    #scope
    _.extend($scope, {
      currentDialog : []

      showDialog: (incident, user)->
        $state.go('account.messages.dialog', {incident: incident.id, user: user.id})

    })

    #helpers

    #event handler

    #run
    $scope.messagesByIncident = messagesByIncident

])