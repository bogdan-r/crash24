angular.module(UserControllers).controller('ProfileCtrl', [
  '$scope'
  '$state'
  'UserProfile'
  ($scope, $state, UserProfile)->

    #var

    #scope
    _.extend($scope, {
      getProfile: ()->

    })

    #helpers

    #event handler

    #run
    UserProfile.get((user)->
      $scope.user = user
    , (err)->
      if(err.status == 403)
        $state.go('index')
    )
])