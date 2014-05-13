angular.module(Resources).factory('UserProfile', [
  '$resource'
  ($resource)->
    UserProfile = $resource('/api/user/profile')

    UserProfile
])