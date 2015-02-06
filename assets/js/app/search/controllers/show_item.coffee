angular.module('app.modules.search.controllers').controller('IncidentShowFromResultCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$stateParams'
  '$sce'
  '$q'
  '$location'
  '$timeout'
  'Incident'
  'Message'
  'mapApiLoad'
  'CurrentPlaceStorage'
  'AccountIncidentCollection'
  ($rootScope, $scope, $state, $stateParams, $sce, $q, $location, $timeout, Incident, Message, mapApiLoad, CurrentPlaceStorage, AccountIncidentCollection)->
    #var
    _deferIncident = $q.defer()
    _sendMessageSuccessTimeout = null

    #scope
    _.extend($scope, {
      incident : {}
      errors : {}
      incidentMessage : {}
      isShowMessageForm : false
      isOwnIncident : false
      isLoadingSendMessage : false

      messageSendSuccessed : false

      trustVideoSrc : (src)->
        $sce.trustAsResourceUrl(src)

      goToSearch : ->
        $rootScope.$broadcast('closeIncidentItem', $scope.incident)
        $state.go('search.result', CurrentPlaceStorage.getPlaceParams())

      sendMessage : (params)->
        params.userRecipient = $scope.incident.user
        params.incidentId = $scope.incident.id
        $scope.isLoadingSendMessage = true
        $scope.messageSendSuccessed = true
        Message.sendMessage(params).$promise.then((message)->
          $scope.isLoadingSendMessage = false
          $scope.resetIncidentMessageField()
          _sendMessageSuccessTimeout = $timeout(()->
            $scope.messageSendSuccessed = false
          , 5000)
        , (err)->
          $scope.isLoadingSendMessage = false
          $scope.errors = err.data.errors
        )

      showMessageForm : ()->
        $scope.isShowMessageForm = true

      resetError : (error)->
        $scope.errors[error] = []

      resetIncidentMessageField : ()->
        for name, val of $scope.incidentMessage
          $scope.incidentMessage[name] = ''
    })

    #helpers

    #event handler
    $scope.$on('$stateChangeSuccess', (e, toState, toParam, fromState, fromParam)->
      if fromState.name.indexOf('search') == -1
        _deferIncident.promise.then((incident)->
          CurrentPlaceStorage.set({
            lat : incident.lat
            long : incident.long
            place : incident.place
            boundLocation : incident.boundedBy
          })
          $rootScope.$broadcast('firstLoadIncidentItem', incident)
        )
    )
    #run
    Incident.get({id : $stateParams.id}, (incident)->
      $scope.incident = incident
      AccountIncidentCollection.get(incident.id).then((incidentCollectionItem)->
        if _.isUndefined(incidentCollectionItem)
          $scope.isOwnIncident = false
        else
          $scope.isOwnIncident = true
      )
      mapApiLoad(()->
        $rootScope.$broadcast('loadIncidentItem', incident)
      )
      _deferIncident.resolve(incident)
    )
])