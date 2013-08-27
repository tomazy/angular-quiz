module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.initConfig
    clean:
      build:
        src: ['scripts', 'styles', 'images', 'views', 'bower_components']
    copy:
      main:
        files: [
          expand: true
          cwd: 'dist'
          src: '**'
          dest: './'
        ]

  grunt.registerTask 'default', ['clean', 'copy']
