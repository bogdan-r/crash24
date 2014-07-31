angular.module('app.modules.user.services').factory('AccountIncidentCollection', [
  '$q'
  '$timeout'
  'Incident'
  ($q, $timeout, Incident)->
    class AccountIncidentCollection
      constructor : ()->
        @_incidents = []

      load : ->
        Incident.findByAccount().$promise

      getAll : ()->
        defer = $q.defer()
        if _.isEmpty(@_incidents)
          @load().then((incidents)=>
            @_incidents = incidents
            defer.resolve(@_incidents)
          , (err)=>
            defer.reject(err)
          )
          defer.promise
        else
          defer.resolve(@_incidents)
          defer.promise

      get : (incidentId)->
        defer = $q.defer()
        @getAll().then(()=>
          incidentIndex = @indexOf(incidentId)
          defer.resolve(@_incidents[incidentIndex])
        , (err)->
          defer.reject(err)
        )
        defer.promise

      add : (incidentParam)->
        defer = $q.defer()
        incident = new Incident(incidentParam)
        incident.$save.then((result)=>
          @_incidents.push(result)
          defer.resolve(@_incidents)
        , (err)=>
          defer.reject(err)
        )
        defer.promise

      delete : (incidentId)->
        defer = $q.defer()
        incidentIndex = @indexOf(incidentId)
        Incident.delete({id : incidentId}).$promise.then(()=>
          @_incidents.splice(incidentIndex, 1);
          defer.resolve()
        , (err)=>
          defer.reject(err)
        )
        defer.promise

      indexOf : (item)->
        itemId = if typeof item == 'number' or typeof item == 'string' then item else item.id
        index = -1
        _.any @_incidents, (x, i) ->
          if x.id == itemId
            index = i
            return true
        index


    return new AccountIncidentCollection()

])