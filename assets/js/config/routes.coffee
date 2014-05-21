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
    .state('logout', {
        url : ''
        template : ''
        controller : 'LogoutCtrl'
      })
    .state('account', {
        abstract : true
        url : '/account'
        templateUrl : RouterHelper.templateUrl('user/account')
        resolve : {
          userLoad : ['UserProfile', '$state', (UserProfile, $state)->
            UserProfile.get().$promise.then(
              (user)->
                return user
            , (err)->
              if(err.status == 403)
                $state.go('main')
            )
          ]
        }
        controller : 'AccountCtrl'
      })
    .state('account.profile', {
        url : '/profile'
        templateUrl : RouterHelper.templateUrl('user/account_profile')
        controller : 'ProfileCtrl'
      })
    .state('account.incidents', {
        url : '/incidents'
        templateUrl : RouterHelper.templateUrl('user/account_incidents')
        controller : 'AccountIncidentsCtrl'
      })
    .state('account.incidents.add', {
        url : '/add'
        views : {
          '@account' : {
            templateUrl : RouterHelper.templateUrl('user/account_incidents_add')
            controller : 'AccountIncidentsAddCtrl'
          }
        }

      })
])