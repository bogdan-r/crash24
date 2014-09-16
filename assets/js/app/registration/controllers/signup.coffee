angular.module('app.modules.registration.controllers').controller('SignupCtrl', [
  '$scope'
  '$window'
  'User'
  ($scope, $window, User)->

    #var

    #scope
    _.extend($scope, {

      signup : (userParam)->
        user = new User(userParam)
        errors : {}
        user.$save().then(
          ->
            $window.location = '/'
        , (err)->
            $scope.errors = err.data.errors
        )

      resetError : (error)->
        $scope.errors[error] = []
    })
])