angular.module('app.modules.user.controllers').controller('AccountCtrl', [
  '$scope'
  '$state'
  'UserProfile'
  'userLoad'
  ($scope, $state, UserProfile, userLoad)->

    #var

    #scope
    _.extend($scope, {
      user : userLoad

    })

    #helpers

    #event handler

    #run

])