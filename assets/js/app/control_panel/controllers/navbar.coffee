angular.module(ControlPanelControllers).controller('NavbarCtrl', [
  '$scope'
  'User'
  ($scope, User)->
    $scope.someVal = 'someval'

    qqq = User.get({userId : 123}, (user)->
      console.log(user)
    ,(err)->
      console.log(err)
    )



])