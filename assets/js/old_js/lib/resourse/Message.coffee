angular.module('app.resources').factory('Message', [
  '$resource'
  ($resource)->
    Message = $resource('/api/message', null, {
      'sendMessage' : {
        method : 'POST',
        url : '/api/send_message'
      }
    })

])