var adminLayout = require('./../utils/adminLayout');

module.exports.routes = {

  /* WEB ROUTES*/
  '/': 'Web/welcomeController',

  /*angular templates*/
  'get /angular_templates': 'Web/angular_templatesController.show',

  /*users*/
  'post /api/user': 'Api/userController.create',
  'get /api/user/profile': 'Api/userController.profile',
  'put /api/user/profile': 'Api/userController.update',
  'put /api/user/password': 'Api/userController.updatePassword',
  'post /api/user/uploadAvatar': 'Api/userController.uploadAvatar',
  'get /api/user/verification': 'Api/userController.verification',
  'get /api/user/getVerificateTokenByEmail': 'Api/userController.getVerificateTokenByEmail',

  /*incidents*/
    /*common*/
    'post /api/incident/search': 'Api/incidentController.search',
    'post /api/incident/searchmap': 'Api/incidentController.searchMap',
    'get /api/incident/:id': 'Api/incidentController.show',

    /*for account*/
    'post /api/incident': 'Api/incidentController.create',
    'get /api/account/incident': 'Api/incidentController.findByAccount',
    'put /api/incident/:id': 'Api/incidentController.update',


  /*messages*/
  'post /api/send_message': 'Api/messageController.create',

  /*locate info*/
  'get /api/get_country_by_name/:title': 'Api/locateInfoController.findCountryByName',
  'get /api/get_city_by_name/:title': 'Api/locateInfoController.findCityByName',

  /*auth*/
  'post /api/login': 'Api/authController.login',
  'get /logout': 'Api/authController.logout',




  /* ADMIN ROUTES*/
  'get /api/admin/users/': 'Api/Admin/userController.index',
  'get /api/admin/users/:id': 'Api/Admin/userController.show',


  /*other route*/
  '/admin*': {
    controller: 'Admin/welcomeController',
    skipRegex: /^[^?]+\./,
    locals: {
      layout: 'layouts/admin/layout'
    }
  },

  '/*': {
    controller: 'Web/welcomeController',
    skipRegex: /^[^?]+\./
  }


};
