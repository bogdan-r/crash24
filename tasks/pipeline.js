/**
 * grunt/pipeline.js
 *
 * The order in which your css, javascript, and template files should be
 * compiled and linked from your views and static HTML files.
 *
 * (Note that you can take advantage of Grunt-style wildcard/glob/splat expressions
 * for matching multiple files.)
 */



// CSS files to inject in order
//
// (if you're using LESS with the built-in default config, you'll want
//  to change `assets/styles/importer.less` instead.)
var cssFilesToInject = [
    'styles/bootstrap/**/*.css',
    'styles/libs/nanoscroller.css',
    'styles/compiled/layout.css',
    'styles/compiled/elements.css',
	'styles/**/*.css'
];


// Client-side javascript files to inject in order
// (uses Grunt-style wildcard/glob/splat expressions)
var jsFilesToInject = [

	// Dependencies like sails.io.js, jQuery, or Angular
	// are brought in here
	'js/dependencies/jquery-1.11.0.min.js',
	'js/dependencies/underscore-min.js',
	'js/dependencies/select2.min.js',
	'js/dependencies/angular/angular.min.js',
	'js/dependencies/angular/*.js',
	'js/dependencies/bootstrap/*.js',
	'js/dependencies/**/*.js',

	// All of the rest of your client-side js files
	// will be injected here in no particular order.
    'js/boot.js',
    /*configs*/
	'js/config/**/*.js',
    /*libs*/
        /*components*/
        'js/lib/components/module.js',
        'js/lib/components/**/*.js',
        /*directives*/
        'js/lib/directives/module.js',
        'js/lib/directives/**/*.js',
        /*filters*/
        'js/lib/filters/module.js',
        'js/lib/filters/**/*.js',
        /*resourse*/
        'js/lib/resourse/module.js',
        'js/lib/resourse/**/*.js',
        /*services*/
        'js/lib/services/module.js',
        'js/lib/services/**/*.js',
    /*app*/
        /*modal windows*/
        'js/app/modals/module.js',
        'js/app/modals/**/*.js',
        /*pages*/
        'js/app/pages/module.js',
        'js/app/pages/**/*.js',
        /*control panel*/
        'js/app/control_panel/module.js',
        'js/app/control_panel/**/*.js',
        /*registration*/
        'js/app/registration/module.js',
        'js/app/registration/**/*.js',
        /*user*/
        'js/app/user/module.js',
        'js/app/user/**/*.js',
        /*search*/
        'js/app/search/module.js',
        'js/app/search/**/*.js',
    'js/app/app.js'
];


// Client-side HTML templates are injected using the sources below
// The ordering of these templates shouldn't matter.
// (uses Grunt-style wildcard/glob/splat expressions)
//
// By default, Sails uses JST templates and precompiles them into
// functions for you.  If you want to use jade, handlebars, dust, etc.,
// with the linker, no problem-- you'll just want to make sure the precompiled
// templates get spit out to the same file.  Be sure and check out `tasks/README.md`
// for information on customizing and installing new tasks.
var templateFilesToInject = [
	'templates/**/*.html'
];








// Prefix relative paths to source files so they point to the proper locations
// (i.e. where the other Grunt tasks spit them out, or in some cases, where
// they reside in the first place)
module.exports.cssFilesToInject = cssFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});
module.exports.jsFilesToInject = jsFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});
module.exports.templateFilesToInject = templateFilesToInject.map(function(path) {
	return 'assets/' + path;
});
