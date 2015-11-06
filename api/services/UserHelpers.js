var UserHelpers = {}

UserHelpers.convertUserToSafe = function(user){
    var safeListAttrs = ['id', 'name', 'username', 'avatars']
    return _.pick(user, safeListAttrs)
}
module.exports = UserHelpers