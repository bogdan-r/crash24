angular.module('app.services').factory('Kladr', [
  '$http'
  ($http)->
    class Kladr
      TOKEN = '539f459cfca916ab22a1f895'
      KEY = '6beb30ec2f19be6d7242f203a8f5165ebab1403d'
      URL = 'http://kladr-api.ru/api.php'
      constructor : ()->
        @_initParams = {
          token : TOKEN
          key : KEY
          url : URL
          callback : 'JSON_CALLBACK'
          limit : 5
        }
      sourse : (params)->
        query = _.extend(@_initParams, params)
        $http.jsonp(URL, {params : query})


    new Kladr()
])