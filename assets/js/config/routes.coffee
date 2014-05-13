angular.module(Crash24).config([
  '$stateProvider',
  '$urlRouterProvider',
  '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider)->
    $locationProvider.html5Mode(true);
    $locationProvider.hashPrefix('!');
    $urlRouterProvider.otherwise('/')

    $stateProvider
    .state('main', {
        url : '/'
        templateUrl : RouterHelper.templateUrl('welcome/index')
        controller : 'WelcomeCtrl'
      })
    .state('main.index', {
        url : ''
        templateUrl : RouterHelper.templateUrl('welcome/welcome_face')
      })
    .state('signup', {
        url : '/signup'
        templateUrl : RouterHelper.templateUrl('auth/signup')
        controller : 'SignupCtrl'
      })
    .state('signin', {
        url : '/signin'
        templateUrl : RouterHelper.templateUrl('auth/signin')
        controller : 'SigninCtrl'
      })
    .state('profile', {
        url : '/profile'
        templateUrl : RouterHelper.templateUrl('user/profile')
        controller : 'ProfileCtrl'
      })
])