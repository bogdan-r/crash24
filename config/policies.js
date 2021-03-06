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
        verification : true,
        profile : 'authenticated',
        uploadAvatar : 'authenticated',
        update : 'authenticated',
        updatePassword : 'authenticated',
        getVerificateTokenByEmail : 'authenticated'
    },

    /*incidents*/
    'Api/incidentController' : {
        '*' : false,
        show : true,
        search : true,
        searchMap : true,
        create : ['authenticated', 'isVerificate'],
        findByAccount : ['authenticated', 'isVerificate'],
        showByAccount : ['authenticated', 'isVerificate'],
        update : ['authenticated', 'isVerificate'],
        delete : ['authenticated', 'isVerificate'],
        restore : ['authenticated', 'isVerificate']
    },

    /*messages*/
    'Api/messageController' : {
        '*' : false,
        create : true
    }


};