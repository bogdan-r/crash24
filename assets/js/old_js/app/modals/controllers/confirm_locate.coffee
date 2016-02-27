angular.module('app.modules.modals.controllers').controller('ConfirmLocateCtrl', [
  '$scope'
  '$modalInstance'
  '$timeout'
  '$q'
  'mapApiLoad'
  'Kladr'
  'LocateDefinition'
  ($scope, $modalInstance, $timeout, $q, mapApiLoad, Kladr, LocateDefinition)->


    #var
    _cityAutocompleteTimeout = null

    #scope

    _.extend($scope, {
      isEnableChouseCity : false
      notFoundCity : false
      status : {
        isOpenDropdown : false
      }
      cityAutocompliteList : []

      showChouseCityField : ->
        @isEnableChouseCity = true

      cityAutocomplete : ($event)->
        $timeout.cancel(_cityAutocompleteTimeout)
        _cityAutocompleteTimeout = $timeout(->
          Kladr.sourse({
            contentType : 'city'
            withParent : 1
            query : $event.target.value
          }).success((data)->
            $scope.cityAutocompliteList = data.result
            if isEmptyLocateList()
              $scope.hideLocateList()
            else
              $scope.showLocateList()
          ).error(()->
            #TODO обработать ошибку
          )
        ,500)

        if $event.target.value == ''
          $scope.hideLocateList()
          $scope.cityAutocompliteList = []


      confirmCity : ()->
        geocodeCity($scope.locateCity).then(()->
          $modalInstance.close()
        )

      confirmCustomCity : ()->
        #TODO разобраться почему не работает ng-model
        geocodeCity($('#cityField').val()).then(()->
          $modalInstance.close()
        ,()->
          $scope.notFoundCity = true
          $timeout(()->
            $scope.notFoundCity = false
          , 3000)
        )

      chouseCity : ($event, city)->
        cityStringParents = if city.parents.length then ", #{city.parents[0].name} #{city.parents[0].type}" else ""
        #TODO избавиться от обращения к jquery
        $('#cityField').val("#{city.type} #{city.name}#{cityStringParents}")
        return

      showLocateList : ->
        $scope.status.isOpenDropdown = true

      showLocateListHandler : ($event)->
        $event.preventDefault()
        $event.stopPropagation()
        if !isEmptyLocateList()
          $scope.showLocateList()

      hideLocateList : ->
        $scope.status.isOpenDropdown = false

      hideLocateListHandler : ($event)->
        $event.preventDefault()
        $event.stopPropagation()
        $timeout(()->
          $scope.hideLocateList()
        , 200)


    })

    #helpers

    isEmptyLocateList = ->
      !$scope.cityAutocompliteList.length

    geocodeCity = (cityName)->
      deferred = $q.defer()
      ymaps.geocode(cityName, {
        results : 1
      }).then((result)->
        city = result.geoObjects.get(0)
        if city != undefined
          LocateDefinition.setCity(city)
          deferred.resolve()
        else
          deferred.reject()
      , ()->
        deferred.reject()
      )
      return deferred.promise

    #run

    mapApiLoad(->
      ymaps.geolocation.get({
        provider : 'yandex'
        mapStateAutoApply : true
      }).then((result)->
        $scope.$apply(->
          $scope.locateCity = result.geoObjects.get(0).properties.get('name')
        )
      )
    )


])