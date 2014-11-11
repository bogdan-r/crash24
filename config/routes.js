/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `config/404.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {


    // Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, etc. depending on your
    // default view engine) your home page.
    //
    // (Alternatively, remove this and add an `index.html` file in your `assets` directory)
    '/': 'Web/welcomeController',

    /*angular templates*/
    'get /angular_templates' : 'Web/angular_templatesController.show',

    /*users*/
    'post /api/user' :        'Api/userController.create',
    'get /api/user/profile' : 'Api/userController.profile',
    'put /api/user/profile' : 'Api/userController.update',
    'put /api/user/password' : 'Api/userController.updatePassword',
    'post /api/user/uploadAvatar' : 'Api/userController.uploadAvatar',

    /*incidents*/
        /*common*/
        'post /api/incident/search' :    'Api/incidentController.search',
        'post /api/incident/searchmap' : 'Api/incidentController.searchMap',
        'get /api/incident/:id' :        'Api/incidentController.show',

        /*for account*/
        'post /api/incident' :             'Api/incidentController.create',
        'get /api/account/incident' :      'Api/incidentController.findByAccount',
        'put /api/incident/:id' :          'Api/incidentController.update',


    /*locate info*/
    'get /api/get_country_by_name/:title' : 'Api/locateInfoController.findCountryByName',
    'get /api/get_city_by_name/:title' :    'Api/locateInfoController.findCityByName',

    /*auth*/
    'post /api/login' : 'Api/authController.login',
    'get /logout' :     'Api/authController.logout',

    /*other route*/
    '/*' :{
        controller : 'Web/welcomeController',
        skipRegex : /^[^?]+\./
    }


};
