angular.module(Resources).factory('User', [
  '$resource'
  ($resource)->
    User = $resource('/user/:userId')

    User
])