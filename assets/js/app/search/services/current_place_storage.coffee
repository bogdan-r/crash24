angular.module('app.modules.search.services').factory('CurrentPlaceStorage', [
  ()->
    class CurrentPlaceStorage
      constructor : ()->
        @_cityInfo = {}

      get : (key)->
        @_cityInfo[key]

      set : (key, value)->
        if typeof key == 'object'
          @_cityInfo = _.extend(@_cityInfo, key)
          return
        else
          @_cityInfo[key] = value
          return

      remove : (key)->
        delete @_cityInfo[key]

      getPlaceParams : ->
        if @isSetPlaceParams
          @_cityInfo
        else
          {}

      isSetPlaceParams : ->
        return @get('lat') && @get('long') && @get('place')

    return new CurrentPlaceStorage()
])