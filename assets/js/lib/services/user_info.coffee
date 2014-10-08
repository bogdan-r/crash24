angular.module('app.services').factory('UserInfo', [
  '$rootScope'
  '$q'
  'UserProfile',
  ($rootScope, $q, UserProfile)->
    class UserInfo

      constructor : ()->
        @_user = {}

      get : (forcedLoad = false)->
        defer = $q.defer()
        if _.isEmpty(@_user) || forcedLoad == true
          UserProfile.get().$promise.then(
            (user)=>
              @_user = user
              defer.resolve(@_user)
          , (err)=>
            defer.reject(err)
          )
          defer.promise
        else
          defer.resolve(@_user)
          defer.promise

      update : (params)->
        defer = $q.defer()
        UserProfile.update(null, params).$promise.then(
          (user)=>
            @_user = _.extend(@_user, user)
            defer.resolve(@_user)
            $rootScope.$broadcast('UserInfo_update', user)
          , (err)=>
            defer.reject(err)
        )
        defer.promise

      setAvatars : (avatars)->
        @_user.avatars = avatars
        $rootScope.$broadcast('UserInfo_setAvatars', @_user.avatars)

      getAvatar : (avatars, avatar)->
        if _.isEmpty(avatars)
          return '/images/fallback/default_user.png'
        else
          return avatars[avatar] + '?cd=' + new Date().getTime()

    return new UserInfo()
])