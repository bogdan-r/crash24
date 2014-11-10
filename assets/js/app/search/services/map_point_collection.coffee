angular.module('app.modules.search.services').factory('MapPointCollection', [
  '$q'
  'Incident'
  ($q, Incident)->
    class MapPointCollection
      constructor : ()->
        @_mapPoints = []

      get : ()->
        @_mapPoints

      load : (params = {}, clearPoints = false)->
        defer = $q.defer()
        _points = []

        if clearPoints == true
          @_mapPoints = []

        Incident.searchMap(params, (incidents)=>
          for incident, i in incidents
            continue if _.any(@_mapPoints, (x, i)=> return true if x.incident.id == incident.id )

            _points.push({
              incident : incident
              geometry: {
                type: 'Point'
                coordinates: [incident.lat, incident.long]
              },
              properties : {
                incident : incident
                isActive : false
                balloonContentHeader: incident.title
                date : moment(incident.date).format('DD.MM.YYYY')
              }
            })

          @_mapPoints = @_mapPoints.concat(_points)
          defer.resolve(@_mapPoints)
        )
        defer.promise


    return new MapPointCollection()
])