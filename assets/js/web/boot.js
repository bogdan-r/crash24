'use strict'

import angular from 'angular';
import ngAnimate from 'angular-animate'
import ngResource from 'angular-resource'
import uiRouter from 'angular-ui-router'
import uiBootstrap from 'angular-ui-bootstrap'


import 'js/vendor/ya-map-2.2'
import 'angular-file-upload/dist/angular-file-upload.min'
import 'ui-router-extras/release/ct-ui-router-extras'

import runConfig from './config/run'
import routes from './config/routes'
import appComponents from './app/module'
import appServices from './lib/services/module'
console.log(appServices)


angular.module('app',[
  appComponents,
  appServices,
  ngAnimate,
  ngResource,
  uiRouter,
  uiBootstrap,
  //'ct.ui.router.extras',
  'yaMap',
  'angularFileUpload'
]).config(routes)
  .run(runConfig)