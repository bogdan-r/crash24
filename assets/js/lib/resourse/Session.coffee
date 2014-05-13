angular.module(Resources).factory('Session', [
  '$resource'
  ($resource)->
    Session = $resource('/api/user/:userId')

    Session
])