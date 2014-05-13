angular.module(RegistrationControllers).controller('SignupCtrl', [
  '$scope'
  '$window'
  'User'
  ($scope, $window, User)->

    #var

    #scope
    _.extend($scope, {
      signup : (userParam)->
        user = new User(userParam)
        user.$save().then(
          ->
            $window.location = '/'
        , (err)->
            console.log(err)
        )
    })
])