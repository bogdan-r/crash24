angular.module('app.modules.search.services').factory('MapPointCollection', [
  '$q'
  'DataStorageCollection'
  'Incident'
  ($q, DataStorageCollection, Incident)->
    class MapPointCollection extends DataStorageCollection

      load : (params = {}, clearPoints = false)->
        defer = $q.defer()
        _points = []

        if clearPoints == true
          @_collection = []

        @_resourse.searchMap(params, (result)=>
          for item, i in result
            continue if _.any(@_collection, (x, i)=> return true if x.incident.id == item.id )

            _points.push({
              incident : item
              geometry: {
                type: 'Point'
                coordinates: [item.lat, item.long]
              },
              properties : {
                incident : item
                isActive : false
                balloonContentHeader: item.title
                date : moment(item.date).format('DD.MM.YYYY')
              }
            })

          @_collection = @_collection.concat(_points)
          defer.resolve(@_collection)
        )
        defer.promise


    return new MapPointCollection(Incident, {loadMethod : 'searchMap'})
])