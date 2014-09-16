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

      delete : (incidentId)->
        defer = $q.defer()
        indexBeforeDelete = @indexOf(incidentId)
        @_incidents[indexBeforeDelete].isDeleted = true
        @_incidents[indexBeforeDelete].indexPromise = indexBeforeDelete

        Incident.delete({id : incidentId}).$promise.then(()=>
          defer.resolve()
        , (err)=>
          defer.reject(err)
        )
        defer.promise.then(()=>
          @_incidents[indexBeforeDelete].isCompliteDeleted = true
          @_deletedIncidentPromise['incidentPromise_' + indexBeforeDelete] = $timeout(()=>
            index = @indexOf(incidentId)
            @_incidents.splice(index, 1);
            delete @_deletedIncidentPromise['incidentPromise_' + indexBeforeDelete]
          , @INCIDENT_TIME_DELETED)
        )
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

      restore : (incidentId)->
        index = indexOf(incidentId)
        indexPromise = @_incidents[index].indexPromise
        @_incidents[index].isDeleted = false
        $timeout.cancel(@_deletedIncidentPromise['incidentPromise_' + indexPromise])

        Incident.restore({id : incidentId}).$promise.then(()=>
          @_incidents[index].isCompliteDeleted = false
        )

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