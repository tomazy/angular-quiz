LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload')(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static(require('path').resolve(dir))

# Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'

loadEnv = (environment) ->
  config = require('./config.json')
  extend = require('util')._extend
  extend(config.default, config[environment])

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # configurable paths
  yeomanConfig =
    app: 'app'
    dist: 'dist'

  try
    yeomanConfig.app = require('./bower.json').appPath or yeomanConfig.app
  catch e

  grunt.initConfig
    yeoman: yeomanConfig
    replace:
      dist:
        options:
          variables: loadEnv('development')
          prefix: '@@'
        files: [
          cwd: '.tmp'
          expand: true
          src: ['**/*.{js,html}']
          dest: '.tmp/'
        ]
    watch:
      coffee:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['test/**/*.coffee']
        tasks: ['coffee:test']
      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass:server']
      haml:
        files: ['<%= yeoman.app %>/{,*/}*.haml']
        tasks: ['haml']
      karma:
        files: [
          '{.tmp,<%= yeoman.app %>}/scripts/**/*.js'
          '{.tmp,<%= yeoman.app %>}/test/spec/**/*.js'
        ]
        tasks: ['replace', 'karma:uwatch:run']
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        files: [
          '{.tmp,<%= yeoman.app %>}/{,*/}*.html'
          '{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css'
          '{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js'
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
        tasks: ['replace']
    connect:
      options:
        port: 8888
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet,
              mountFolder(connect, '.tmp'),
              mountFolder(connect, yeomanConfig.app)
            ]
      test:
        options:
          port: 8889
          middleware: (connect) ->
            [
              mountFolder(connect, '.tmp'),
              mountFolder(connect, 'test')
            ]
      dist:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, yeomanConfig.dist)
            ]
    open:
      server:
        url: 'http://localhost:<%= connect.options.port %>'
    clean:
      dist:
        files: [
          dot: true
          src: [
            '.tmp',
            '<%= yeoman.dist %>/*',
            '!<%= yeoman.dist %>/.git*'
          ]
        ]
      server: '.tmp'
    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        '<%= yeoman.app %>/scripts/{,*/}*.js'
      ]
    coffee:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'test/'
          src: '**/*.coffee'
          dest: '.tmp/test'
          ext: '.js'
        ]
    haml:
      options:
        language: 'ruby'
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>'
          src: '{,*/}*.haml'
          dest: '.tmp'
          ext: '.html'
        ]
    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '.tmp/styles'
        generatedImagesDir: '.tmp/images/generated'
        imagesDir: '<%= yeoman.app %>/images'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: '<%= yeoman.app %>/bower_components'
        httpImagesPath: '/images'
        httpGeneratedImagesPath: '/images/generated'
        httpFontsPath: '/styles/fonts'
        relativeAssets: false
      dist: {}
      server:
        options:
          debugInfo: true
    rev:
      dist:
        files:
          src: [
            '<%= yeoman.dist %>/scripts/{,*/}*.js',
            '<%= yeoman.dist %>/styles/{,*/}*.css',
            '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
            '<%= yeoman.dist %>/styles/fonts/*'
          ]
    useminPrepare:
      html: '.tmp/index.html'
      options:
        dest: '<%= yeoman.dist %>'
    usemin:
      html: ['<%= yeoman.dist %>/{,*/}*.html']
      css: ['<%= yeoman.dist %>/styles/{,*/}*.css']
      options:
        dirs: ['<%= yeoman.dist %>']
    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%= yeoman.dist %>/images'
        ]
    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.svg'
          dest: '<%= yeoman.dist %>/images'
        ]
    htmlmin:
      dist:
        options: {}
          #removeCommentsFromCDATA: true
          ## https://github.com/yeoman/grunt-usemin/issues/44
          ##collapseWhitespace: true
          #collapseBooleanAttributes: true
          #removeAttributeQuotes: true
          #removeRedundantAttributes: true
          #useShortDoctype: true
          #removeEmptyAttributes: true
          #removeOptionalTags: true
        files: [
            expand: true
            cwd: '<%= yeoman.app %>'
            src: ['*.html', 'views/*.html']
            dest: '<%= yeoman.dist %>'
          ,
            expand: true
            cwd: '.tmp'
            src: ['*.html', 'views/*.html']
            dest: '<%= yeoman.dist %>'
        ]
    # Put files not handled in other tasks here
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>'
          dest: '<%= yeoman.dist %>'
          src: [
            '*.{ico,png,txt}',
            '.htaccess',
            'bower_components/json3/**',
            'bower_components/es5-shim/**',
            'images/{,*/}*.{gif,webp}',
            'styles/fonts/*'
          ]
        ,
          expand: true
          cwd: '.tmp/images'
          dest: '<%= yeoman.dist %>/images'
          src: [
            'generated/*'
          ]
        ]
    concurrent:
      server: [
        'coffee:dist',
        'haml',
        'compass:server',
      ]
      test: [
        'coffee',
        'haml',
        'compass'
      ]
      dist: [
        'coffee',
        'haml',
        'compass:dist',
        'imagemin',
      ]
    karma:
      unit:
        configFile: 'karma.conf.js'
        singleRun: true
      e2e:
        configFile: 'karma-e2e.conf.js'
        singleRun: true
      uwatch:
        configFile: 'karma.conf.js'
        background: true
        browsers: ['PhantomJS']
    cdnify:
      dist:
        html: ['<%= yeoman.dist %>/*.html']
    ngmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.dist %>/scripts'
          src: '*.js'
          dest: '<%= yeoman.dist %>/scripts'
        ]
    uglify:
      dist:
        files:
          '<%= yeoman.dist %>/scripts/scripts.js': [
            '<%= yeoman.dist %>/scripts/scripts.js'
          ]

  grunt.registerTask 'environment', (target) ->
    grunt.log.writeln("Loading environment: #{target}")
    grunt.config.set('replace.dist.options.variables', loadEnv(target))

  grunt.registerTask 'set-environment', () ->
    env = 'development'
    env = 'production' if grunt.option('production')
    env = 'test'       if grunt.option('test')
    grunt.task.run ["environment:#{env}"]

  grunt.registerTask 'server', (target) ->
    if target == 'dist'
      grunt.task.run(['build', 'open', 'connect:dist:keepalive'])

    grunt.task.run [
      'set-environment',
      'clean:server',
      'concurrent:server',
      'replace',
      'connect:livereload',
      'open',
      'watch'
    ]

  grunt.registerTask 'test:unit', [
    'clean:server',
    'concurrent:test',
    'replace',
    'connect:test',
    'karma:unit'
  ]

  grunt.registerTask 'test:watch', [
    'clean:server',
    'concurrent:test',
    'replace',
    'connect:livereload',
    'connect:test',
    'karma:uwatch',
    'watch'
  ]

  grunt.registerTask 'test:e2e', [
    'environment:test',
    'clean:server',
    'concurrent:test',
    'replace',
    'connect:livereload',
    'karma:e2e'
  ]

  grunt.registerTask 'test', [
    'test:unit'
  ]

  grunt.registerTask 'build', [
    'set-environment',
    'clean:dist',
    'concurrent:dist',
    'replace',
    'useminPrepare',
    'htmlmin',
    'concat',
    'copy',
    'cdnify',
    'ngmin',
    'cssmin',
    'uglify',
    'rev',
    'usemin'
  ]

  grunt.registerTask 'default', [
    'jshint',
    'test',
    'build'
  ]
