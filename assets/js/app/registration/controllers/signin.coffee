angular.module('app.modules.registration.controllers').controller('SigninCtrl', [
  '$scope'
  '$window'
  '$http'
  '$state'
  ($scope, $window, $http, $state)->

    #var

    #scope
    _.extend($scope, {
      signin: (userParam)->
        $http.post('/api/login', userParam).success((data, status, headers, config)->
          $window.location = $state.href('account.profile')
        )
    })
])