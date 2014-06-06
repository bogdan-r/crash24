angular.module('app.resources').factory('User', [
  '$resource'
  ($resource)->
    User = $resource('/api/user/')

    User
])