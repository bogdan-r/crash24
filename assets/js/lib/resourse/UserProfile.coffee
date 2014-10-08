angular.module('app.resources').factory('UserProfile', [
  '$resource'
  ($resource)->
    UserProfile = $resource('/api/user/profile', null, {
      update : {
        method : 'PUT'
      }
      updatePassword :{
        method : 'PUT'
        url : '/api/user/password'
      }
    })

    UserProfile
])


