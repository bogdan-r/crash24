angular.module('app.modules.search.services').factory('CurrentPlaceStorage', [
  ()->
    class CurrentPlaceStorage
      constructor : ()->
        @_cityInfo = {}

      get : (key)->
        @_cityInfo[key]

      set : (key, value)->
        if typeof key == 'object'
          @_cityInfo = key
          return
        else
          @_cityInfo[key] = value
          return
      getPlaceParams : ->
        if @isSetPlaceParams
          {
            lat : @get('lat')
            long : @get('long')
            place : @get('place')
          }
        else
          {}

      isSetPlaceParams : ->
        return @get('lat') && @get('long') && @get('place')

    return new CurrentPlaceStorage()
])