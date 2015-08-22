function MessageProvider(){

}

MessageProvider.isWrongParamsData = function(messageParams){
  var isWrongUserRecipientVal = _.isUndefined(messageParams.userRecipient)
    && _.isNull(messageParams.userRecipient)
    && _.isEmpty(messageParams.userRecipient)
  var isWrongIncidentVal = _.isUndefined(messageParams.incident)
    && _.isNull(messageParams.incident)
    && _.isEmpty(messageParams.incident)
  if (isWrongUserRecipientVal || isWrongIncidentVal) {
    return true
  }else{
    return false
  }
}

module.exports = MessageProvider