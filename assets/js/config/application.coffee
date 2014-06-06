angular.module("app").run([
  '$rootScope'
  ($rootScope)->
    $rootScope.settings = {}
])