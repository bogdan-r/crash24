angular.module(RegistrationControllers).controller('LogoutCtrl', [
  '$scope'
  '$window'
  '$http'
  ($scope, $window, $http)->

    #var

    $window.location = '/logout'
])