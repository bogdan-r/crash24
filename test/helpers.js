
exports.createUserReq = function(agent, stub, done){
    agent.post('/api/user')
        .send(stub)
        .end(function(err, res){
            done()
        })
}

exports.UserStub = function(mixin){
    return _.extend({
        username : "Admin",
        email : "someemail@gmail.com",
        password : '123',
        confirm_password : '123'
    }, mixin || {})
}

exports.IncidentStub = function(mixin){
    return _.extend({
        title : "Инцидент",
        lat : 38.234234,
        long : 38.234234,
        boundedBy : [[55.889235,37.596076],[55.898265,37.603586]],
        date : '2013-10-21',
        description : 'Мурановская улица Россия, Москва',
        original_video_url : 'http://www.youtube.com/watch?v=R_vyCTrmFsM'
    }, mixin || {})
}