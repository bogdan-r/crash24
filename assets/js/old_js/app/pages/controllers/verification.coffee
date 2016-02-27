angular.module('app.modules.pages.controllers').controller('VerificationCtrl', [
  '$scope',
  '$stateParams',
  'User'
  'UserInfo'
  ($scope, $stateParams, User, UserInfo)->

    #var

    #scope
    _.extend($scope, {
      errors : {}
      verificateParams : {}

      isVerificateSuccess : false

      verificate : (verificateParams)->
        verificateParams.token = $stateParams.token
        User.verification(verificateParams, ()->
          UserInfo.get(true)
          $scope.isVerificateSuccess = true
        , (err)->
          $scope.errors = err.data.errors
        )

      resetError : (error)->
        $scope.errors[error] = []
    })

    #helpers

    #event handler

    #run

])