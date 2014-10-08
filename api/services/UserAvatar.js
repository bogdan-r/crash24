var q = require('q');
var path = require('path');

var ORIGINAL_AVATAR_NAME = 'avatar_original';
var AVATAR_URL_ASSET = 'attachments/uploads/User/avatar/';
var AVATAR_URL_ASSET_PUBLIC = '/uploads/User/avatar/';
var AVATAR_LIST = [
    {
        name: 'avatar',
        width: 160,
        height: 160,
        ext : '.png'
    },
    {
        name: 'avatar_small',
        width: 35,
        height: 35,
        ext : '.png'
    }
];

function UserAvatar (options){
    this.options = options;
    this._nameAvatars = [];
}


UserAvatar.prototype.generateAvatars = function(){
    var self = this;

    return ImageAction.identify(self.options.originalAvatar).then(function(info){
        var resizeList = [];

        for(var i = 0; i < AVATAR_LIST.length; i++){
            self._nameAvatars.push(AVATAR_LIST[i].name);
            resizeList.push(ImageAction.crop({
                srcPath : self.options.originalAvatar,
                dstPath : path.dirname(self.options.originalAvatar) + '/' + AVATAR_LIST[i].name + AVATAR_LIST[i].ext,
                format: 'png',
                width : AVATAR_LIST[i].width,
                height : AVATAR_LIST[i].height
            }))
        }
        return resizeList
    }).spread(function(){
        return self._nameAvatars
    }).fail(function(err){
        throw new Error(err);
    })
}

UserAvatar.getOriginalAvatarName = function(){
    return ORIGINAL_AVATAR_NAME
}

UserAvatar.getAvatarsUrl = function(){
    return {
        avatarUrlAsset : AVATAR_URL_ASSET,
        avatarUrlAssetPublic : AVATAR_URL_ASSET_PUBLIC
    }
}
UserAvatar.getAvatarList = function(){
    return AVATAR_LIST
}

UserAvatar.getAvatarUrlPublic = function(id){
    var avatars = {};
    var avatarList = UserAvatar.getAvatarList();
    var avatarUrl = UserAvatar.getAvatarsUrl();

    for(var i = 0; i < avatarList.length; i++){
        avatars[avatarList[i].name] = avatarUrl.avatarUrlAssetPublic + id + '/' + avatarList[i].name + avatarList[i].ext;
    }

    return avatars
}

module.exports = UserAvatar