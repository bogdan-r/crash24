angular.module('app.resources').factory('User', [
  '$resource'
  ($resource)->
    User = $resource('/api/user/', null, {
      verification : {
        method : 'GET'
        url : '/api/user/verification'
      }
    })

    User
])