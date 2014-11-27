var request = require('supertest');
var _ = require('underscore');
var helpers = require('../../../helpers');

describe('UsersController', function() {

    afterEach(function(done){
        User.destroy(function(err){
            if(err) return done(err);
            done();
        });
    })

    describe('#create()', function(){
        it ('пароли не совпадают', function(done){
            var stub = helpers.UserStub();
            delete stub.confirm_password
            request(sails.hooks.http.app)
                .post('/api/user')
                .send(stub)
                .expect(400, done)
        });
        it ('создание юзера', function(done){
            request(sails.hooks.http.app)
                .post('/api/user')
                .send(helpers.UserStub())
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('username', 'Admin');
                    done()
                })
        });

        it ('юзер с таким именем уже существует', function(done){
            User.create(helpers.UserStub()).exec(function(err){
                if(err) return done(err);

                request(sails.hooks.http.app)
                    .post('/api/user')
                    .send(helpers.UserStub())
                    .expect(400)
                    .end(function(err, res){
                        if(err) done(err);
                        res.body.should.not.equal(undefined);
                        res.body.should.have.property('errors');
                        res.body.errors.should.be.an.instanceOf(Object).and.have.property('username');
                        done()
                    })
            })

        });
    });

    describe('#profile()', function(){
        var agent;
        beforeEach(function(done){
            agent = request.agent(sails.hooks.http.app)
            helpers.createUserReq(agent, helpers.UserStub(), done)
        });
        it('профиль юзера', function(done){
            agent.get('/api/user/profile')
                .expect(200)
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('username', 'Admin');
                    done()
                })
        });
    });

    describe('#update()', function(){
        var agent;
        beforeEach(function(done){
            agent = request.agent(sails.hooks.http.app)
            helpers.createUserReq(agent, helpers.UserStub(), done)
        });

        it('обновление данных юзера', function(done){
            agent.put('/api/user/profile')
                .send(helpers.UserStub({username : 'superAdmin'}))
                .expect(200)
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('username', 'superAdmin');
                    done()
                })
        });
    });

    describe('#updatePassword()', function(){
        beforeEach(function(done){
            agent = request.agent(sails.hooks.http.app);
            helpers.createUserReq(agent, helpers.UserStub(), done);
        });

        it('обновление пароля юзера', function(done){
            agent.put('/api/user/password')
                .send({
                    old_password : '123',
                    new_password : '1234',
                    new_password_confirm : '1234'
                })
                .expect(200)
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('username');
                    done()
                })
        });

        it('неправильный старый пароль', function(done){
            agent.put('/api/user/password')
                .send({
                    old_password : '1234',
                    new_password : '123',
                    new_password_confirm : '123'
                })
                .expect(400)
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('errors');
                    res.body.errors.should.be.an.instanceOf(Object).and.have.property('old_password');
                    done()
                })
        });

        it('пароли не совпадают', function(done){
            agent.put('/api/user/password')
                .send({
                    old_password : '123',
                    new_password : '1234',
                    new_password_confirm : '123'
                })
                .expect(400)
                .end(function(err, res){
                    res.body.should.not.equal(undefined);
                    res.body.should.have.property('errors');
                    res.body.errors.should.be.an.instanceOf(Object).and.have.property('new_password_confirm');
                    done()
                })
        })
    })

});