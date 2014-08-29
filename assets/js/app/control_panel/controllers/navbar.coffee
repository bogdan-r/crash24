angular.module('app.modules.controlPanel.controllers').controller('NavbarCtrl', [
  '$scope'
  '$timeout'
  ($scope, $timeout)->

    #var

    #scope
    _.extend($scope, {
      isOpenDropdownUser : false
      showUserDropmenuHandler : ->
        $scope.isOpenDropdownUser = true

      hideUserDropmenuHandler : ->
        $scope.isOpenDropdownUser = false

    })
    #helpers

    #event handler


    #run

])