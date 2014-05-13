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
        console.log(req.session);
        return res.view();
    }
};
