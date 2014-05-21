var Sails = require('sails')
var sinon = require('sinon');
var assert = require('assert');
var app;


describe('User controller', function(){
    before(function(done) {

        // Lift Sails and start the server
        Sails.lift({

            log: {
                level: 'error'
            }

        }, function(err, sails) {
            app = sails;
            done(err, sails);
        });
    });

})