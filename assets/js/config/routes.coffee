angular.module('app').config([
  '$stateProvider',
  '$urlRouterProvider',
  '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider)->
    $locationProvider.html5Mode(true);
    $locationProvider.hashPrefix('!');
    $urlRouterProvider.when('/', '/search')
    $urlRouterProvider.otherwise('/search')

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
        }

      })
    .state('search.result', {
        url : '?lat&long&place&boundLocation&dateFrom&dateTo&orderBy'
        templateUrl : RouterHelper.templateUrl('search/search_result')
        controller : 'IncidentSearchResultCtrl',
      })
    .state('search.showitem', {
        url : '^/item/:id'
        templateUrl : RouterHelper.templateUrl('search/search_result_show')
        controller : 'IncidentShowFromResultCtrl'
      })
    .state('search.showitem.fromMap', {
        data : {
          fromMap : true
        }
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
    .state('verification', {
          url : '/user/verification?token'
          templateUrl : RouterHelper.templateUrl('pages/verification')
          controller : 'VerificationCtrl'
        })
    .state('account', {
        abstract : true
        url : '/account'
        templateUrl : RouterHelper.templateUrl('user/account')
        resolve : {
          userLoad : ['UserInfo', '$state', (UserInfo, $state)->
            UserInfo.get().then(
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
        resolve : {
          userLoad : ['UserInfo', '$state', (UserInfo, $state)->
            UserInfo.get().then((user)->
              if user.isVerification == false
                $state.go('account.verificateIt')
            )
          ]
        }

      })
    .state('account.incidents.show', {
        url : '/show/:id'
        views : {
          '@account' : {
            templateUrl : RouterHelper.templateUrl('user/account_incidents_show')
            controller : 'AccountIncidentsShowCtrl'
          }
        }

      })
    .state('account.incidents.edit', {
        url : '/edit/:id'
        views : {
          '@account' : {
            templateUrl : RouterHelper.templateUrl('user/account_incidents_edit')
            controller : 'AccountIncidentsEditCtrl'
          }
        }
      })
    .state('account.verificateIt', {
          url : '/edit/verificate'
          views : {
            '@account' : {
              templateUrl : RouterHelper.templateUrl('user/account_verificate_forbidden')
              controller : 'AccountIncidentsEditCtrl'
            }
          }
        })
    .state('account.messages', {
          url : '/messages'
          views : {
            '@account' : {
              templateUrl : RouterHelper.templateUrl('user/account_messages')
              controller : 'AccountMessagesCtrl'
            }
          }
          resolve: {
            messagesByIncident: ['AccountIncidentCollection', 'UserInfo', 'userLoad', (AccountIncidentCollection, UserInfo, userLoad)->
              AccountIncidentCollection.getAll().then(->
                return UserInfo.getMessages()
              )
            ]
          }
        })
    .state('account.messages.dialog', {
          url : '/dialog?incident&user&type'
          views : {
            '@account' : {
              templateUrl : RouterHelper.templateUrl('user/account_messages_dialog')
              controller : 'AccountMessagesDialogCtrl'
            }
          }
        })
    .state('pages', {
      abstract : true
      url : '/pages'
      views : {
        '' : {
          templateUrl : RouterHelper.templateUrl('pages/common')
        }
      }
      controller : 'CommonPageCtrl'
    })
    .state('pages.rules', {
      url : '/rules'
      templateUrl : RouterHelper.templateUrl('pages/rules')
    })
])