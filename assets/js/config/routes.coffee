angular.module(Crash24).config([
  '$stateProvider',
  '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider)->
    $urlRouterProvider.otherwise('/')

    $stateProvider
    .state('index', {
        url : '/'
      })
])