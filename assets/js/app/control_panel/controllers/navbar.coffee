angular.module('app.modules.controlPanel.controllers').controller('NavbarCtrl', [
  '$scope'
  '$timeout'
  'UserInfo'
  ($scope, $timeout, UserInfo)->

    #var

    #scope
    _.extend($scope, {
      user : {}
      userAvatar : null
      isOpenDropdownUser : false

      showUserDropmenuHandler : ->
        $scope.isOpenDropdownUser = true

      hideUserDropmenuHandler : ->
        $scope.isOpenDropdownUser = false

    })
    #helpers

    #event handler
    $scope.$on('UserInfo_setAvatars', (e, avatars)->
      $scope.userAvatar = UserInfo.getAvatar(avatars, 'avatar_small')
    )

    $scope.$on('UserInfo_update', (e, user)->
      $scope.user = user
    )

    #run
    UserInfo.get().then((user)->
      $scope.user = user
      $scope.userAvatar = UserInfo.getAvatar($scope.user.avatars, 'avatar_small')
    )

])