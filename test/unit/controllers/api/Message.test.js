var request = require('supertest');
var _ = require('underscore');
var async = require('async')
var helpers = require('../../../helpers');

describe('MessagesController', function () {
  afterEach(function (done) {
    async.parallel([
        function (cb) {
          User.destroy(function (err) {
            if (err) return cb(err);
            cb();
          });
        },
        function (cb) {
          Message.destroy(function (err) {
            if (err) return cb(err);
            cb();
          });
        }
      ],
      function (err) {
        if (err) return done(err);
        done()
      });

  })
})