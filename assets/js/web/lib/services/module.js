'use strict'

import angular from 'angular'

import StoreService from './store_service'

export default angular.module('app.services', [

]).factory('StoreFactory', StoreService)
  .name