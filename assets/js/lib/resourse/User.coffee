angular.module(Resources).factory('User', [
  '$resource'
  ($resource)->
    User = $resource('/api/user/')

    User
])