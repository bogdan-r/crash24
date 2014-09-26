module.exports = function(req, res, next){
    if(req.isAuthenticated() && req.user.admin === true){
        return res.redirect('/admin')
    }else{
        return next()
    }
};