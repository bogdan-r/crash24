angular.module('app.resources').factory('UserProfile', [
  '$resource'
  ($resource)->
    UserProfile = $resource('/api/user/profile')

    UserProfile
])