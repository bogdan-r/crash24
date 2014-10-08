var _ = require('underscore');
var q = require('q');
var url = require('url');
var http = require('http');
var fs = require('node-fs');
var im = require('imagemagick');

var THUMB_URL_ASSET = 'attachments/uploads/Incident/thumb/';
var THUMB_URL_ASSET_PUBLIC = '/uploads/Incident/thumb/';

var THUMB_ORIGINAL = 'original.jpg';
var THUMB_SMALL = 'small.jpg';

function SocialVideo (videoUrl){
    this.videoUrl = videoUrl
    this.videoUrlParsed =  url.parse(this.videoUrl, true);
    this.videoInfo = this._determineVideoInfo(this.videoUrlParsed)
}

SocialVideo.prototype.getVideoInfo = function(){
    return this.videoInfo
}

SocialVideo.prototype.setVideoThumbs = function(values){
    var self = this;
    var thumbUrlAssetInstance = THUMB_URL_ASSET + values.id;
    var thumbUrlInstanceOriginal = thumbUrlAssetInstance + '/' + THUMB_ORIGINAL;
    var thumbUrlInstanceSmall = thumbUrlAssetInstance + '/' + THUMB_SMALL;

    var resizeSmallOptons = {
        width : 120,
        srcPath : thumbUrlInstanceOriginal,
        dstPath : thumbUrlInstanceSmall,
        quality: 1
    }

    var processSetVideoThumbs = this._getThumbRequest(this.videoInfo.videoThumbnailUrl).then(function(imageData){
        return [imageData, self._mkdir(thumbUrlAssetInstance)];
    }).spread(function(imageData){
        return self._writeThumb(thumbUrlInstanceOriginal, imageData)
    }).then(function(){
        return [self._resizeThumb(resizeSmallOptons)]
    });

    return processSetVideoThumbs

}

SocialVideo.prototype._determineVideoInfo = function(videoUrl){
    var videoType, embedUrl, videoThumbnailUrl;
    if(videoUrl.host && videoUrl.host.search(/youtube/) && videoUrl.query.v){
        videoType = 'youtube'
        embedUrl = '//www.youtube.com/embed/' + videoUrl.query.v
        videoThumbnailUrl = 'http://img.youtube.com/vi/' + videoUrl.query.v + '/0.jpg'
    }
    return {
        videoType : videoType,
        embedUrl : embedUrl,
        videoThumbnailUrl : videoThumbnailUrl
    }
}

SocialVideo.prototype._getThumbRequest = function(thumbUrl){
    var defer = q.defer()
    http.get(thumbUrl, function (response) {
        var imageData = '';

        response.setEncoding('binary');
        response.on('data', function (chunk) {
            imageData += chunk;
        })
        response.on('end', function () {
            defer.resolve(imageData);
        })

    }).on('error', function(e){
            defer.reject(new Error('Не удалсь подключиться к серверу.' + e.message))
        });
    return defer.promise
}

SocialVideo.prototype._mkdir = function(thumbUrlAssetInstance){
    var defer = q.defer();
    fs.mkdir(thumbUrlAssetInstance, 0777, true, function(err){
        if(err){
            console.log('mkdir err', err);
            defer.reject(err);
        }else{
            defer.resolve();
        }
    })
    return defer.promise
}
SocialVideo.prototype._writeThumb = function(url, imgData){
    var defer = q.defer()
    fs.writeFile(url, imgData, 'binary', function (err) {
        if(err){
            console.log('writeFile err', err);
            defer.reject(err);
        }else{
            defer.resolve();
        }
    })
    return defer.promise
}
SocialVideo.prototype._resizeThumb = function(options){
    var defer = q.defer();

    im.resize(options, function(err, stdout, stderr){
        if(err){
            console.log('resize err', err);
            defer.reject(err);
        }else{
            defer.resolve();
        }
    })
    return defer.promise
}

SocialVideo.getThumbsUrl = function(){
    return {
        thumbUrlAsset : THUMB_URL_ASSET,
        thumbUrlAssetPublic : THUMB_URL_ASSET_PUBLIC
    }
}
SocialVideo.getThumbsName = function(){
    return {
        original : THUMB_ORIGINAL,
        small : THUMB_SMALL
    }
}

module.exports = SocialVideo;