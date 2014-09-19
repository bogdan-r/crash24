angular.module("app").run([
  '$rootScope'
  '$modal'
  '$window'
  'LocateDefinition'
  ($rootScope, $modal, $window, LocateDefinition)->
    $rootScope.settings = {}


    _modalInstance = null
    if !LocateDefinition.isExistLocate()
      LocateDefinition.setDefault()
      _modalInstance = $modal.open({
        templateUrl : RouterHelper.templateUrl('modals/confirm_locate')
        controller : 'ConfirmLocateCtrl'
        backdrop : 'static'
      })

    _modalInstance?.result.then(()->
      LocateDefinition.setExistLocate()
      $window.location.reload()
    )
])