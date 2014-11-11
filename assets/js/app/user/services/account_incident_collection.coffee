angular.module('app.modules.user.services').factory('AccountIncidentCollection', [
  '$q'
  '$timeout'
  'Incident'
  ($q, $timeout, Incident)->
    class AccountIncidentCollection
      constructor : ()->
        @_incidents = []
        @_deletedIncidentPromise = {}
        @INCIDENT_TIME_DELETED = 5000

      load : ->
        Incident.findByAccount().$promise

      getAll : (directAccess = false)->
        if directAccess == true
          @_incidents
        else
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
        incident.$save().then((result)=>
          @_incidents.push(result)
          defer.resolve(@_incidents)
        , (err)=>
          defer.reject(err)
        )
        defer.promise

      update : (incident)->
        defer = $q.defer()
        Incident.update({id : incident.id}, incident).$promise.then((result)=>
          index = @indexOf(incident.id)
          @_incidents.splice(index, 1, result);
          defer.resolve(@_incidents)
        , (err)=>
          defer.reject(err)
        )
        defer.promise


      indexOf : (item)->
        itemId = if typeof item == 'number' or typeof item == 'string' then parseInt(item, 10) else item.id
        index = -1
        _.any @_incidents, (x, i) ->
          if x.id == itemId
            index = i
            return true
        index


    return new AccountIncidentCollection()

])