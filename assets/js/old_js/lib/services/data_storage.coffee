angular.module('app.services').factory('DataStorageCollection', [
  '$q'
  ($q)->
    class DataStorageCollection
      constructor: (resourse, resourseParam = {})->
        @_collection = []
        @_resourse = resourse
        @_resourseParam = resourseParam
        @_resourseParam.loadMethod = resourseParam.loadMethod || 'load'

      load: ()->
        @_resourse[@_resourseParam.loadMethod]().$promise

      getAll : (directAccess = false)->
        if directAccess == true
          @_collection
        else
          defer = $q.defer()
          if _.isEmpty(@_collection)
            @load().then((result)=>
              @_collection = result
              defer.resolve(@_collection)
            , (err)=>
              defer.reject(err)
            )
            defer.promise
          else
            defer.resolve(@_collection)
            defer.promise

      get: (id)->
        defer = $q.defer()
        @getAll().then(()=>
          index = @indexOf(id)
          defer.resolve(@_collection[index])
        , (err)->
          defer.reject(err)
        )
        defer.promise

      add: (itemCollectionParams)->
        defer = $q.defer()
        itemCollection = new @_resourse(itemCollectionParams)
        itemCollection.$save().then((result)=>
          @_collection.push(result)
          defer.resolve(@_collection)
        , (err)=>
          defer.reject(err)
        )
        defer.promise

      update: (itemCollection)->
        defer = $q.defer()
        @_resourse.update({id : itemCollection.id}, itemCollection).$promise.then((result)=>
          index = @indexOf(itemCollection.id)
          @_collection.splice(index, 1, result);
          defer.resolve(@_collection)
        , (err)=>
          defer.reject(err)
        )
        defer.promise

      delete: ()->

      indexOf: (item)->
        itemId = if typeof item == 'number' or typeof item == 'string' then parseInt(item, 10) else item.id
        index = -1
        _.any @_collection, (x, i) ->
          if x.id == itemId
            index = i
            return true
        index
])