angular.module(RegistrationControllers).controller('SigninCtrl', [
  '$scope'
  '$window'
  '$http'
  ($scope, $window, $http)->

    #var

    #scope
    _.extend($scope, {
      signin: (userParam)->
        $http.post('/api/login', userParam).success((data, status, headers, config)->
          $window.location = '/profile'
        )
    })
])