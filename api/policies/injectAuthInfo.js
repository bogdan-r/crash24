/**
 * injectUser
 *
 * @module :: Policy
 *
 */
module.exports = function(req, res, next) {
    res.locals.User = {};
    res.locals.isAuth = false;
    if (req.isAuthenticated()) {
        res.locals.User = req.user;
        res.locals.isAuth = true;
    }

    next();
};
