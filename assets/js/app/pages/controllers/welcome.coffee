angular.module('app.modules.pages.controllers').controller('WelcomeCtrl', [
  '$scope'
  '$modal'
  'mapApiLoad'
  'LocateDefinition'
  '$controller'
  ($scope, $modal, mapApiLoad, LocateDefinition, $controller)->

    #var
    _modalInstance = null

    #scope

    #helpers

    #event handler

    #run


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