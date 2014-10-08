angular.module('app.modules.user.controllers').controller('ProfileCtrl', [
  '$rootScope'
  '$scope'
  '$state'
  '$cookies'
  '$timeout'
  'UserInfo'
  'UserProfile'
  'FileUploader'
  ($rootScope, $scope, $state, $cookies, $timeout, UserInfo, UserProfile, FileUploader)->

    #var
    _successTimeout = null
    _avatarSuccessTimeout = null
    _passwordSuccessTimeout = null

    #scope
    _.extend($scope, {
      user : {}
      errors : {}
      isLoadingUserUpdate : false
      isLoadingPassUpdate : false
      isLoadingAvatarUpdate : false
      updateSuccessed : false
      avatarUpdateSuccessed : false
      passwordUpdateSuccessed : false

      avatarUploader : new FileUploader({
        url : '/api/user/uploadAvatar'
        alias : 'avatar'
        headers : {
          'X-XSRF-TOKEN' : $cookies['XSRF-TOKEN']
        }
        removeAfterUpload : true
      })

      updateProfileInfo : (user)->
        $scope.isLoadingUserUpdate = true
        UserInfo.update(user).then(
          (user)->
            $scope.isLoadingUserUpdate = false
            $scope.updateSuccessed = true
            $timeout.cancel(_successTimeout)
            _successTimeout = $timeout(()->
              $scope.updateSuccessed = false
            , 5000)
            #if $scope.avatarUploader.queue.length != 0

          , (err)->
            $scope.isLoadingUserUpdate = false
            $scope.errors = err.data.errors

        )

      updatePassword : (passInfo)->
        $scope.isLoadingPassUpdate = true
        UserProfile.updatePassword(passInfo, (user)->
          $scope.isLoadingPassUpdate = false
          $scope.passwordData = {}
          $scope.errors = {}
          $scope.passwordUpdateSuccessed = true
          $timeout.cancel(_passwordSuccessTimeout)
          _passwordSuccessTimeout = $timeout(()->
            $scope.passwordUpdateSuccessed = false
          , 5000)

        , (err)->
          $scope.isLoadingPassUpdate = false
          $scope.errors = err.data.errors
        )


      resetError : (error)->
        $scope.errors[error] = []

    })
    #helpers

    #event handler
    $scope.avatarUploader.onWhenAddingFileFailed = (item, filter, options)->
      switch filter.name
        when 'imageFilter'
          $scope.errors['avatar'] = ['Вы можете загружать только картинки']
        when 'maxBytes'
          $scope.errors['avatar'] = ['Слишком большой файл']


    $scope.avatarUploader.onErrorItem = (item, response)->
      $scope.errors['avatar'] = response.errors.avatar
      $scope.isLoadingAvatarUpdate = false

    $scope.avatarUploader.onAfterAddingFile = (item)->
      $scope.errors['avatar'] = []
      if $scope.avatarUploader.queue.length > 1
        $scope.avatarUploader.removeFromQueue(0)

    $scope.avatarUploader.onSuccessItem = (item, response, status, headers)->
      $scope.isLoadingAvatarUpdate = false
      UserInfo.setAvatars(response.avatars)
      $scope.avatarUpdateSuccessed = true
      $timeout.cancel(_avatarSuccessTimeout)
      _avatarSuccessTimeout = $timeout(()->
        $scope.avatarUpdateSuccessed = false
      , 5000)

    $scope.avatarUploader.onCompleteItem = ()->
      $scope.isLoadingAvatarUpdate = false

    $scope.avatarUploader.onBeforeUploadItem = ()->
      $scope.isLoadingAvatarUpdate = true


    #run
    $scope.avatarUploader.filters.push({
      name : "imageFilter",
      fn : (item, options)->
        type = '|' + item.type.slice(item.type.lastIndexOf('/') + 1) + '|';
        return '|jpg|png|jpeg|bmp|gif|'.indexOf(type) isnt -1;
    })

    $scope.avatarUploader.filters.push({
      name : "maxBytes",
      fn : (item, options)->
        if item.size > 1000000
          return false
        else
          return true
    })

    UserInfo.get().then((user)->
      $scope.user = _.clone(user)
    )

])