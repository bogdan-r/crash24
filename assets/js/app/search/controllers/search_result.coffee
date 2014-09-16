angular.module('app.modules.search.controllers').controller('IncidentSearchResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  'Incident'
  'LocateDefinition'
  'CurrentPlaceStorage'
  ($rootScope, $scope, $state, $stateParams, Incident, LocateDefinition, CurrentPlaceStorage)->
    #var
    _cityInfo = LocateDefinition.getCityInfo()
    _cityInfoOptions = {}


    #scope
    _.extend($scope, {
      #TODO сделать коллекцию, для избавления от лишних запросов
      incidents : []
    })
    #helpers

    #event handler

    #run

    if !CurrentPlaceStorage.isSetPlaceParams()
      if $stateParams.lat && $stateParams.long && $stateParams.place
        _cityInfoOptions = {
          lat : $stateParams.lat
          long : $stateParams.long
          place : $stateParams.place
        }
      else
        _cityInfoOptions = {
          lat : _cityInfo.coord[0]
          long : _cityInfo.coord[1]
          place : _cityInfo.name
        }
      CurrentPlaceStorage.set(_cityInfoOptions)

    #NOTE обычная загрузка проишествий
    Incident.search({
        lat : CurrentPlaceStorage.get('lat')
        long : CurrentPlaceStorage.get('long')
        take : 100}, (incidents)->
      $scope.incidents = incidents
    )
])