/**
 * injectUser
 *
 * @module :: Policy
 *
 */
module.exports = function(req, res, next) {
    res.locals.layout = 'layout_admin';

    next();
};
