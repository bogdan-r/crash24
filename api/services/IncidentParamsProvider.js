function IncidentParamsProvider (){

}
IncidentParamsProvider.retrieve = function(params){
    var socialVideo = new SocialVideo(params['video']);
    var socialVideoInfo = socialVideo.getVideoInfo();
    var errors = new ErrorStorage();

    if(socialVideoInfo.videoType === undefined){
        errors.add('video', 'Ссылка на видео не верна')
    }
    if(params['lat'] === undefined || params['long'] === undefined){
        errors.add('place', 'Не удалось определить место проишествие, укажите место на карте')
    }
    if(errors.hasError()){
        return {errors : errors.get()}
    }

    var incidentParams = {
        title :       params['title'],
        video :       socialVideoInfo.embedUrl,
        video_type :  socialVideoInfo.videoType,
        original_video_url : params['video'],
        lat :         parseFloat(params['lat']),
        long :        parseFloat(params['long']),
        date :        params['date'],
        description : params['description'],
        place :       params['place'],
        boundedBy :   params['boundedBy'],
        user :        params['user']
    };

    return {
        incidentParams : incidentParams,
        socialVideo : socialVideo
    }
}

module.exports = IncidentParamsProvider
