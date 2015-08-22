var request = require('supertest');
var _ = require('underscore');
var helpers = require('../../../helpers');

describe('IncidentController', function() {
    afterEach(function(done){
        Incident.destroy(function(err){
            if(err) return done(err);
            done();
        });
    });

    describe('#create()', function(done){

    })

})