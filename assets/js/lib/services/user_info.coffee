angular.module('app.services').factory('UserInfo', [
  '$rootScope'
  '$q'
  'UserProfile',
  'AccountIncidentCollection'
  ($rootScope, $q, UserProfile, AccountIncidentCollection)->
    class UserInfo

      constructor : ()->
        @_user = {}
        @messagesByIncident = {}

      get : (forcedLoad = false)->
        defer = $q.defer()
        if _.isEmpty(@_user) || forcedLoad == true
          UserProfile.get().$promise.then(
            (user)=>
              @_user = user
              defer.resolve(@_user)
              $rootScope.$broadcast('UserInfo_load', user)
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

      getMessages : ()->
        @_convertMessagesByIncident()

      getDialogInfo : (incidentId, userId, type)->
        currentTypeMessages = @messagesByIncident[type]
        currentIncidentIndex = @_indexOfPropItem(currentTypeMessages, parseInt(incidentId))
        currentUserIndex = @_indexOfPropItem(currentTypeMessages[currentIncidentIndex].users, parseInt(userId))
        return currentTypeMessages[currentIncidentIndex].users[currentUserIndex]

      addMessage : ()->


      _convertMessagesByIncident : ()->
        propMessageList = ['id', 'createdAt', 'isSentMessage', 'text', 'updatedAt']
        outputMessages = {
          forMe : []
          fromMe : []
        }
        incidents = AccountIncidentCollection.getAll(true)

        allMessages = _.sortBy(@_user.messages, (item)->
          moment(item.createdAt).unix()
        )

        #TODO оптимизировать цикл
        for message in allMessages
          isSelfMessageIncident = @_isIncludePropItem(incidents, message.incident.id)
          if isSelfMessageIncident == true
            @_addFormationMessageByIncident({
              messageType : outputMessages.forMe,
              message : message
              primeryUserType : 'user'
              secondaryUserType : 'userRecipient',
              propMessageList : propMessageList
            })
          else
            @_addFormationMessageByIncident({
              messageType : outputMessages.fromMe,
              message : message
              primeryUserType : 'userRecipient'
              secondaryUserType : 'user',
              propMessageList : propMessageList
            })

        @messagesByIncident = outputMessages
        outputMessages

      _addFormationMessageByIncident : (params)->
        messageType = params.messageType
        message = params.message
        primeryUserType = params.primeryUserType
        secondaryUserType = params.secondaryUserType
        propMessageList = params.propMessageList

        indexIncident = @_indexOfPropItem(messageType, message.incident.id)
        # если инцидента нет в списке
        if indexIncident == -1
          message[primeryUserType].messages = [_.pick(message, propMessageList)]
          message.incident.users = [message[primeryUserType]]
          messageType.push(message.incident)
        else
          verifiableCondition = @_setVerifiableCondition(message.incident.user, message.user.id,
            message[primeryUserType].id,
            message[secondaryUserType].id)
          indexUser = @_indexOfPropItem(messageType[indexIncident].users, verifiableCondition)
          # если юзера нет в списке
          if indexUser == -1
            message[primeryUserType].messages = [_.pick(message, propMessageList)]
            messageType[indexIncident].users.push(message[primeryUserType])
          else
            messageType[indexIncident].users[indexUser].messages.push(_.pick(message, propMessageList))

      _setVerifiableCondition : (incidentUserId, messageUserId, primeryUserId, secondaryUserId)->
        if incidentUserId != messageUserId
          primeryUserId
        else
          secondaryUserId


      _indexOfPropItem : (incomingObj, verifiableCondition)->
        index = -1
        _.some(incomingObj, (objItem, i)->
          if objItem.id == verifiableCondition
            index = i
            return true
        )
        index

      _isIncludePropItem : (incomingObj, verifiableCondition)->
        @_indexOfPropItem(incomingObj, verifiableCondition) != -1



    return new UserInfo()
])