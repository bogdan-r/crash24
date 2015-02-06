angular.module('app.modules.pages.controllers').controller('VerificationCtrl', [
  '$scope',
  '$stateParams',
  'User'
  ($scope, $stateParams, User)->

    #var

    #scope
    _.extend($scope, {
      errors : {}
      verificateParams : {}

      isVerificateSuccess : false

      verificate : (verificateParams)->
        verificateParams.token = $stateParams.token
        User.verification(verificateParams, ()->
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