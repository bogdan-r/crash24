angular.module('app.modules.user.controllers').controller('AccountCtrl', [
  '$scope'
  '$state'
  'UserInfo'
  ($scope, $state, UserInfo)->

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
    UserInfo.get().then((user)->
      $scope.user = user
      $scope.userAvatar = UserInfo.getAvatar($scope.user.avatars, 'avatar')
    )
])