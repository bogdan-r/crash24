angular.module('app.modules.registration.controllers').controller('SigninCtrl', [
  '$scope'
  '$window'
  '$http'
  '$state'
  ($scope, $window, $http, $state)->

    #var

    #scope
    _.extend($scope, {
      errors : {}

      signin: (userParam)->
        $http.post('/api/login', userParam).success((data, status, headers, config)->
          $window.location = $state.href('account.profile')
        ).error((err)->
          $scope.errors = err.errors
        )

      resetError : (error)->
        $scope.errors[error] = []
    })
])