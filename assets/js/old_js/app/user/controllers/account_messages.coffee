angular.module('app.modules.user.controllers').controller('AccountMessagesCtrl', [
  '$scope'
  '$state'
  'messagesByIncident'
  'userLoad'
  ($scope, $state, messagesByIncident, userLoad)->

    #var

    #scope
    _.extend($scope, {
      currentDialog : []

      showDialog: (incident, user, type)->
        $state.go('account.messages.dialog', {incident: incident.id, user: user.id, type: type})

      userMessageThumb: (user)->
        if user.messages[user.messages.length-1].isSentMessage
          userLoad.avatars.avatar_small
        else
          user.avatars.avatar_small
    })

    #helpers

    #event handler

    #run
    $scope.messagesByIncident = messagesByIncident
    console.log $scope.messagesByIncident
])