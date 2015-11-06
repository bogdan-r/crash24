var Sails = require('sails');

before(function(done) {
    Sails.lift({
        log: {
            level: 'error'
        },
        models: {
            connection: 'localDiskDb',
            migrate: 'drop'
        },
        session : {
            db: 'testing'
        },
        csrf : false
    }, function(err, sails) {
        if (err) return done(err);

        done(err, sails);
    });
});

after(function(done) {
    // here you can clear fixtures, etc.
    sails.lower(done);
});