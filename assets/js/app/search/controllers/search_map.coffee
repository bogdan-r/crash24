angular.module('app.modules.search.controllers').controller('MapMainCtrl', [
  '$scope',
  '$state',
  '$stateParams',
  '$q'
  '$timeout'
  'LocateDefinition',
  'CurrentPlaceStorage'
  'mapApiLoad'
  'templateLayoutFactory'
  'Incident'
  'SettingsServ'
  'MapPointCollection'
  ($scope, $state, $stateParams, $q, $timeout, LocateDefinition, CurrentPlaceStorage, mapApiLoad, templateLayoutFactory, Incident, SettingsServ, MapPointCollection)->

    #var
    _deferMap = $q.defer()
    _deferCluster = $q.defer()
    _deferPoint = null
    _map = null
    _cluster = null
    _mapPointCollection = MapPointCollection
    _cityInfo = LocateDefinition.getCityInfo()
    _settings = new SettingsServ
    _activeIncidentIndex = null



    if $stateParams.lat && $stateParams.long
      _cityCoords = [$stateParams.lat, $stateParams.long]
    else
      _cityCoords = _cityInfo.coord

    #scope
    _.extend($scope, {
      points : []
      cityCoords : _cityCoords

      mapsItemOptions : _settings.get('maps:mapsItemOptions')
      searchMapClusterOptions : _settings.get('maps:searchMapClusterOptions')

      clusterLayoutOverrides : {
        build : ()->
          BalloonContentLayout = templateLayoutFactory.get('clusterLayout')
          BalloonContentLayout.superclass.build.call(this);
          angular.element('.jq_cluster_search_item_link').on('click', @onClickClusterItem)

        clear : ()->
          angular.element('.jq_cluster_search_item_link').off('click', @onClickClusterItem)
          BalloonContentLayout = templateLayoutFactory.get('clusterLayout')
          BalloonContentLayout.superclass.clear.call(this);

        onClickClusterItem : (e)->
          e.preventDefault()
          $item = angular.element(@)
          incidentId = $item.data('placemark-incident-id')
          $state.go('search.showitem.fromMap', {id : incidentId}, {})

      }

      afterMapInit : (map)->
        _map = map
        _deferMap.resolve(map)

      afterclusterInit : ($target)->
        _cluster = $target
        _deferCluster.resolve($target)

      chouseIncident : ($event, point)->
        isStateShowItem = $state.current.name == 'search.showitem'
        isStateShowItemFromMap = $state.current.name == 'search.showitem.fromMap'
        if (isStateShowItem or isStateShowItemFromMap) and parseInt($stateParams.id) == parseInt(point.incident.id)
          _resetActivePoint()
          $state.go('search.result', CurrentPlaceStorage.getPlaceParams())
        else
          $state.go('search.showitem.fromMap', {id : point.incident.id}, {})

      itemMouseenter : ($event)->
        iconContentLayout = templateLayoutFactory.get('incidentItemHoverLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      itemMouseleave : ($event)->
        if $event.get('target').properties.get('isActive')
          return
        iconContentLayout = templateLayoutFactory.get('incidentItemLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      itemPropChange : ($event, point)->
        isActive = $event.get('target').properties.get('isActive')
        if isActive
          iconContentLayout = templateLayoutFactory.get('incidentItemActiveLayout')
        else
          iconContentLayout = templateLayoutFactory.get('incidentItemLayout')
        $event.get('target').options.set('iconLayout', iconContentLayout)

      moveMap : ($event)->
        _mapPointCollection.load({
          dateFrom : CurrentPlaceStorage.get('dateFrom')
          dateTo : CurrentPlaceStorage.get('dateTo')
          boundMap : _map.getBounds()
        }).then((points)->
          $scope.points = points
          _deferPoint?.promise.then((index)->
            _setActivePointIndex(index)
            $scope.points[_getActivePointIndex()].properties.isActive = true
            _deferPoint = null
          )

        )

      clusterPlacemarkClick : ($event)->
        $event.preventDefault()
        target = $event.get('target')
        if typeof target.getGeoObjects == 'function'
          if _.isEqual(target.getBounds()[0], target.getBounds()[1])
            _cluster.balloon.open($event.get('target'))
          else
            _map.setBounds(target.getBounds())

    })

    #helpers

    #TODO вынести в отдельную компоненту работу с активной точкой на карте
    _pointsIndexOf = (itemId)->
      index = -1
      _.any $scope.points, (x, i) ->
        if x.incident.id == parseInt(itemId)
          index = i
          return true
      index

    _resetActivePoint = (index)->
      pointIndex = if index then index else _activeIncidentIndex
      return if _.isNull(pointIndex)
      $scope.points[pointIndex].properties.isActive = false
      _activeIncidentIndex = null

    _setActivePointIndex = (index)->
      _activeIncidentIndex = if _pointsIndexOf(index) == -1 then null else _pointsIndexOf(index)

    _getActivePointIndex = ()->
      _activeIncidentIndex

    #event handler
    $scope.$on('chouseSearchPlace', (e, place)->
      _map.setBounds(place.prop.boundedBy, {
        checkZoomRange : true
      })
    )

    $scope.$on('loadIncidentItem', (e, incident)->
      if !_.isNull(_getActivePointIndex())
        _resetActivePoint()
      _setActivePointIndex(incident.id)
      if !_.isNull(_getActivePointIndex())
        $scope.points[_getActivePointIndex()].properties.isActive = true
      else
        _deferPoint = $q.defer()
        _deferPoint.resolve(incident.id)

      if $state.current.data?.fromMap == false or $state.current.data?.fromMap == undefined
        _deferMap.promise.then(->
          _map.setCenter([incident.lat, incident.long], 15, {
            checkZoomRange : true
          })
        )

      return
    )

    $scope.$on('closeIncidentItem', (e, incident)->
      _resetActivePoint(_pointsIndexOf(incident.id))
    )

    $scope.$on('changeSearchFilter', (e)->
      if $state.current.name == 'search.showitem'
        _resetActivePoint(_pointsIndexOf($state.params.id))

      _mapPointCollection.load({
        dateFrom : CurrentPlaceStorage.get('dateFrom')
        dateTo : CurrentPlaceStorage.get('dateTo')
        boundMap : _map.getBounds()
      }, true).then((points)->
        $scope.points = points
      )
    )


    #run

    _deferMap.promise.then(->
      _mapPointCollection.load({
        dateFrom : $stateParams.dateFrom
        dateTo : $stateParams.dateTo
        boundMap : _map.getBounds()
      }).then((points)->
        $scope.points = points
      )
    )

])