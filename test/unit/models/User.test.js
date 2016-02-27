var helpers = require('../../helpers');

describe('UsersModel', function () {

  afterEach(function (done) {
    User.destroy(function (err) {
      if (err) return done(err);
      done();
    });
  })

  describe('Перед тем как создать юзера', function () {
    it('пароль должен быть зашифрован', function (done) {
      User.beforeCreate({
        password: 'password'
      }, function (err, user) {
        user.password.should.not.equal('password')
        done();
      })
    })
  });

  describe('После создания юзера', function () {
    it('проверить отсутствия приватных данных в выдаче', function (done) {
      User.create(helpers.UserStub()).exec(function (err, user) {
        if (err) done(err);

        var outputUser = user.toJSON();
        outputUser.should.not.have.properties('password', 'admin', 'isSetAvatar');
        done();
      })
    });
  });

  describe('Валидация пароля', function () {
    it('пароль совпадает, асинхронный вызов', function (done) {
      User.create(helpers.UserStub()).exec(function (err, user) {
        if (err) done(err);

        user.validPassword('123', function (err, result) {
          if (err) done(err);

          result.should.be.true;
          done()
        })
      })
    });

    it('пароль не совпадает, асинхронный вызов', function (done) {
      User.create(helpers.UserStub()).exec(function (err, user) {
        if (err) done(err);

        user.validPassword('1234', function (err, result) {
          if (err) done(err);

          result.should.be.false;
          done();
        })
      })
    });

    it('пароль совпадает, синхронный вызов', function (done) {
      User.create(helpers.UserStub()).exec(function (err, user) {
        if (err) done(err);

        user.validPassword('123').should.be.true;
        done();
      })
    });

    it('пароль не совпадает, синхронный вызов', function (done) {
      User.create(helpers.UserStub()).exec(function (err, user) {
        if (err) done(err);

        user.validPassword('1234').should.be.false;
        done();
      })
    });
  })

});