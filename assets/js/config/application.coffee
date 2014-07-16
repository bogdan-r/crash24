angular.module("app").run([
  '$rootScope'
  '$modal'
  'LocateDefinition'
  ($rootScope, $modal, LocateDefinition)->
    $rootScope.settings = {}


    _modalInstance = null
    if !LocateDefinition.isExistLocate()

      _modalInstance = $modal.open({
        templateUrl : RouterHelper.templateUrl('modals/confirm_locate')
        controller : 'ConfirmLocateCtrl'
        backdrop : 'static'
      })

    _modalInstance?.result.then(()->
      LocateDefinition.setExistLocate()
    )
])