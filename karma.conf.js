// Karma configuration

module.exports = function(karma){
  // base path, that will be used to resolve files and exclude
  karma.basePath = '';

  karma.frameworks = ['jasmine'];

  // list of files / patterns to load in the browser
  karma.files = [
    'app/bower_components/angular/angular.js',
    'app/bower_components/angular-mocks/angular-mocks.js',
    '.tmp/scripts/**/*.js',
    '.tmp/test/spec/specHelper.js',
    '.tmp/test/spec/**/*Spec.js'
  ];

  // list of files to exclude
  karma.exclude = [
    '.tmp/scripts/modules/firebase_simple_login.js'
  ];

  // test results reporter to use
  // possible values: dots || progress || growl
  karma.reporters = ['progress'];

  // web server port
  karma.port = 8080;

  // cli runner port
  karma.runnerPort = 9100;

  // enable / disable colors in the output (reporters and logs)
  karma.colors = true;

  // level of logging
  // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
  karma.logLevel = karma.LOG_INFO;

  // enable / disable watching file and executing tests whenever any file changes
  karma.autoWatch = false;

  // Start these browsers, currently available:
  // - Chrome
  // - ChromeCanary
  // - Firefox
  // - Opera
  // - Safari (only Mac)
  // - PhantomJS
  // - IE (only Windows)
  karma.browsers = ['Chrome'];

  // If browser does not capture in given timeout [ms], kill it
  karma.captureTimeout = 5000;

  // Continuous Integration mode
  // if true, it capture browsers, run tests and exit
  karma.singleRun = false;
}
