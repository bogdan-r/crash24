angular.module('app.modules.registration.controllers').controller('SignupCtrl', [
  '$scope'
  '$window'
  '$state'
  'User'
  ($scope, $window, $state, User)->

    #var

    #scope
    _.extend($scope, {
      errors : {}
      signup : (userParam)->
        user = new User(userParam)
        $scope.errors = {}
        user.$save().then(
          ->
            $window.location = $state.href('account.profile')
        , (err)->
            $scope.errors = err.data.errors
        )

      resetError : (error)->
        $scope.errors[error] = []
    })
])