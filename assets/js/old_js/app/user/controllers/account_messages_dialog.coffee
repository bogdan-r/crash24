angular.module('app.modules.user.controllers').controller('AccountMessagesDialogCtrl', [
  '$scope'
  '$stateParams'
  'Message'
  'UserInfo'
  'userLoad'
  ($scope, $stateParams, Message, UserInfo, userLoad)->

    #var

    #scope
    _.extend($scope, {
      dialogInfo: UserInfo.getDialogInfo($stateParams.incident, $stateParams.user, $stateParams.type)
      messageText: ''

      sendMessage: ()->
        params = {
          userRecipient: parseInt $stateParams.user
          incidentId: parseInt $stateParams.incident
          text: $scope.messageText
        }

        if $stateParams.type == 'forMe'
          params.userIdIncident = userLoad.id

        Message.sendMessage(params).$promise.then((message)->
          UserInfo.addMessage()
          #TODO сделать без перезагрузки
          location.reload()
        )
    })

    #helpers

    #event handler

    #run
    UserInfo.getUnreadMessagesCount()


])