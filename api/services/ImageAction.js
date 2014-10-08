var q = require('q');
var fs = require('node-fs');
var im = require('imagemagick');

function ImageAction (options){
    this.options = options;
}
ImageAction.identify = function(path){
    var defer = q.defer();
    im.identify(path, function(err, info){
        if(err){
            defer.reject(err)
        }else{
            defer.resolve(info)
        }
    })
    return defer.promise
}

ImageAction.resize = function(options){
    var defer = q.defer();

    im.resize(options, function(err, stdout, stderr){
        if(err){
            defer.reject(err);
        }else{
            defer.resolve();
        }
    })
    return defer.promise
}

ImageAction.crop = function(options){
    var defer = q.defer();

    im.crop(options, function(err, stdout, stderr){
        if(err){
            defer.reject(err);
        }else{
            defer.resolve(options);
        }
    })
    return defer.promise
}


module.exports = ImageAction;