angular.module('app.modules.user.controllers').controller('AccountCtrl', [
  '$scope'
  '$state'
  'UserInfo'
  'userLoad'
  ($scope, $state, UserInfo, userLoad)->

    #var

    #scope
    _.extend($scope, {
      user : {}
      userAvatar : null

    })

    #helpers

    #event handler
    $scope.$on('UserInfo_setAvatars', (e, avatars)->
      $scope.userAvatar = UserInfo.getAvatar(avatars, 'avatar')
    )

    $scope.$on('UserInfo_update', (e, user)->
      $scope.user = user
    )

    #run
    $scope.user = userLoad
    $scope.userAvatar = UserInfo.getAvatar($scope.user.avatars, 'avatar')
])