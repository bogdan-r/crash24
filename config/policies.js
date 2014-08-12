/**
 * Policy Mappings
 * (sails.config.policies)
 *
 * Policies are simple functions which run **before** your controllers.
 * You can apply one or more policies to a given controller, or protect
 * its actions individually.
 *
 * Any policy file (e.g. `api/policies/authenticated.js`) can be accessed
 * below by its filename, minus the extension, (e.g. "authenticated")
 *
 * For more information on how policies work, see:
 * http://sailsjs.org/#/documentation/concepts/Policies
 *
 * For more information on configuring policies, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.policies.html
 */

module.exports.policies = {

    /***************************************************************************
     *                                                                          *
     * Default policy for all controllers and actions (`true` allows public     *
     * access)                                                                  *
     *                                                                          *
     ***************************************************************************/
    '*': 'injectAuthInfo',

    /*users*/
    'Api/userController' : {
        '*' : false,
        create : true,
        profile : 'authenticated'
    },

    /*incidents*/
    'Api/incidentController' : {
        '*' : false,
        show : true,
        search : true,
        searchMap : true,
        create : 'authenticated',
        findByAccount : 'authenticated',
        showByAccount : 'authenticated',
        update : 'authenticated',
        delete : 'authenticated',
        restore : 'authenticated'
    }


};