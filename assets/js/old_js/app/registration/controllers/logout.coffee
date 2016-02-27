angular.module('app.modules.registration.controllers').controller('LogoutCtrl', [
  '$scope'
  '$window'
  '$http'
  ($scope, $window, $http)->

    #var

    $window.location = '/logout'
])