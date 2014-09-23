/**
 * Web/welcomeController.js 
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */

module.exports = {
    /**
     * `Web/welcomeController.index`
     */
    index: function (req, res) {
        res.cookie('XSRF-TOKEN', res.locals._csrf)
        return res.view();
    }
};
