module.exports = function(grunt) {

  grunt.config.set('webpack', {
    options: require('./../../webpack.config.js'),
    dev: {

    }
  });

  grunt.loadNpmTasks('grunt-webpack');
};
