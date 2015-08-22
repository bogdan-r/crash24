angular.module('app.modules.user.controllers').controller('AccountMessagesCtrl', [
  '$scope'
  '$state'
  'messagesByIncident'
  'userLoad'
  ($scope, $state, messagesByIncident, userLoad)->

    #var
    console.log userLoad

    #scope
    _.extend($scope, {
      currentDialog : []

      showDialog: (incident, user, type)->
        $state.go('account.messages.dialog', {incident: incident.id, user: user.id, type: type})

      userMessageThumb: (user)->
        console.log user
        if user.messages[user.messages.length-1].isSentMessage
          console.log 'isSentMessage'
          console.log user
          userLoad.avatars.avatar_small
        else
          console.log user
          console.log 'not isSentMessage'
          user.avatars.avatar_small
    })

    #helpers

    #event handler

    #run
    $scope.messagesByIncident = messagesByIncident
    console.log $scope.messagesByIncident
])