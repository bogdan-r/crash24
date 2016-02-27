angular.module('app.modules.user.controllers').controller('AccountIncidentsEditCtrl', [
  '$scope'
  '$state'
  '$stateParams'
  '$timeout'
  '$q'
  '$filter'
  'LocateDefinition'
  'Incident'
  'AccountIncidentCollection'
  ($scope, $state, $stateParams, $timeout, $q, $filter, LocateDefinition, Incident, AccountIncidentCollection)->

    #var
    _deferIncident = $q.defer()

    _map = null
    _locatePlaceInfo = LocateDefinition.getCityInfo()

    #scope
    _.extend($scope, {
      errors : {}

      placeAutocompliteList : [] #Массив с адресами геолокации

      incidentParam : {} #Параметры для добавления инцидента

      afterMapInit : (map)->
        _map = map
        _deferIncident.promise.then((incident)->
          _map.setBounds(incident.boundedBy, {
            checkZoomRange : true
          })
        )
        return

      setIncidentCoordsHandler : ($event)->
        coords = $event.get('coords')
        _setIncidentCoords(coords)

      updateIncident : (incidentParam)->
        AccountIncidentCollection.update(incidentParam).then(()->
          $state.go('account.incidents')
        , (err)->
          $scope.errors = err.data.errors
        )

      resetError : (error)->
        $scope.errors[error] = []

    #Поиск списка адресов по строке
      relatedAddress : (value)->
        ymaps.geocode(incidentForm.place.value, {
          results : 10
          boundedBy : _locatePlaceInfo.boundedBy
        }).then((result)->
          interimArr = []
          result.geoObjects.each((el)->
            props = el.properties.getAll()
            props.coords = el.geometry.getCoordinates()
            interimArr.push({
              props : props
              value : "#{props.name} #{props.description}"
            })
          )
          return interimArr
        )

      setAddress : ($item)->
        _chousePlace({
          prop : $item.props
          coords : $item.props.coords
        })

      dragIncidentMarker : ($event)->
        _setIncidentCoords($event.get('target').geometry.getCoordinates())

    })

    #helpers

    #TODO вынести работу с данными в отдельную компоненту
    _setValuesPlaceFields = (geoObjProp)->
      $scope.incidentParam.place = "#{geoObjProp.name} #{geoObjProp.description}"

    _chousePlace = (place)->
      _setValuesPlaceFields(place.prop)
      $scope.incidentParam.lat = place.coords[0]
      $scope.incidentParam.long = place.coords[1]
      $scope.incidentParam.boundedBy = place.prop.boundedBy
      $scope.incidentPoint = {
        geometry: {
          type: 'Point'
          coordinates: [place.coords[0], place.coords[1]]
        }
      }
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
      $scope.placeAutocompliteList = []

    _setIncidentCoords = (coords)->
      $scope.incidentParam.lat = coords[0]
      $scope.incidentParam.long = coords[1]
      $scope.incidentPoint = {
        geometry: {
          type: 'Point'
          coordinates: [coords[0], coords[1]]
        }
      }
      ymaps.geocode(coords, {
        results : 1
      }).then((result)->
        geoObject = result.geoObjects.get(0)
        properties = geoObject.properties.getAll()
        $scope.incidentParam.boundedBy = geoObject.properties.getAll().boundedBy
        _setValuesPlaceFields(properties)
        $scope.$apply()
      )


    #event handler

    #run
    AccountIncidentCollection.get($stateParams.id).then((incident)->
      $scope.incidentParam = incident
      $scope.incidentParam.date = $filter('date')(incident.date, 'yyyy-MM-dd')
      $scope.incidentParam.video = incident.original_video_url
      $scope.currentCityCenter = [incident.lat, incident.long]
      $scope.incidentPoint = {
        geometry: {
          type: 'Point'
          coordinates: [incident.lat, incident.long]
        }
      }

      _deferIncident.resolve(incident)

    )

])