'use strict'

import routerHelper from 'js/web/lib/util/router_helper'

routes.$inject = ['$stateProvider', '$urlRouterProvider', '$locationProvider']

export default function routes($stateProvider, $urlRouterProvider, $locationProvider) {
  $locationProvider.html5Mode(true);
  $locationProvider.hashPrefix('!');
  $urlRouterProvider.when('/', '/search');
  $urlRouterProvider.otherwise('/search');

  $stateProvider
    .state('root', {
      abstract: true,
      url: '/',
      templateUrl: routerHelper.templateUrl('pages/index')
    })
    .state('root.main', {
      url: ''
    })

}