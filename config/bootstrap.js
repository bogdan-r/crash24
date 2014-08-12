/**
 * Bootstrap
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#documentation
 */

var fs = require('fs');
var path = require('path');

module.exports.bootstrap = function (cb) {

    var atcSource = path.join(process.cwd(), 'attachments/uploads');
    var atcDest = path.join(process.cwd(), '.tmp/public/uploads');

    sails.on('lifted', function() {
        //TODO криворукий хак, подумать как обойтись без таймера
        setTimeout(function(){
            fs.symlink(atcSource, atcDest, function(err) {});
        },1500)
    });

    cb();
};