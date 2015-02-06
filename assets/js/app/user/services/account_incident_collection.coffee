angular.module('app.modules.user.services').factory('AccountIncidentCollection', [
  '$q'
  'DataStorageCollection'
  'Incident'
  ($q, DataStorageCollection, Incident)->
    class AccountIncidentCollection extends DataStorageCollection

    return new AccountIncidentCollection(Incident, {loadMethod : 'findByAccount'})

])