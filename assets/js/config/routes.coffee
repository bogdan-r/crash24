angular.module('app').config([
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
        templateUrl : RouterHelper.templateUrl('pages/index')
        controller : 'WelcomeCtrl'
      })
    .state('search', {
        abstract : true
        url : '/search'
        views : {
          '' : {
            templateUrl : RouterHelper.templateUrl('search/search')
          }
          'navbar@' : {
            templateUrl : RouterHelper.templateUrl('search/control_panel')
          }
        }

      })
    .state('search.result', {
        url : ''
        templateUrl : RouterHelper.templateUrl('search/search_result')
        controller : 'IncidentSearchResultCtrl'
      })
    .state('search.result.showitem', {
        #TODO изменить название для урла
        url : '^/item/:id'
        templateUrl : RouterHelper.templateUrl('search/search_result_show')
        controller : 'IncidentShowFromResultCtrl'
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
                $state.go('account.profile')
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