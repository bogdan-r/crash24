angular.module('app.resources').factory('Session', [
  '$resource'
  ($resource)->
    Session = $resource('/api/user/:userId')

    Session
])