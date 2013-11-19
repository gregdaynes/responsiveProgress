module.exports = (grunt) ->

	grunt.initConfig
    # !General Filesystem
	  shell:
	    build:
        command: 'rm -rf dev dist .tmp'

    copy:
      css:
        expand: true
        cwd: '.tmp/css/'
        src: ['**/*.css', '**/*.map', '!min/**/*.*']
        dest: 'dev/'
      cssdist:
        expand: true
        cwd: '.tmp/css-min/'
        src: '**/*.css'
        dest: 'dist/'
      js:
        expand: true
        cwd: '.tmp/js/'
        src: '**/*.*'
        dest: 'dev/'
      js_raw:
        expand: true
        cwd: 'src/js/'
        src: '**/*.js'
        dest: 'dev/'
      js_src_coffee:
        expand: true
        cwd: 'src/js/'
        src: '**/*.coffee'
        dest: 'dev/src/js/'
      htmldev:
        expand: true
        flatten: true
        cwd: ''
        src: 'src/*.html'
        dest: 'dev/'
      htmldist:
        expand: true
        cwd: ''
        src: '*.html'
        dest: 'dist/'
      media_dev:
        expand: true
        cwd: 'src/media/'
        src: '**/*.*'
        dest: 'dev/media/'
      media_dist:
        expand: true
        cwd: 'src/media/'
        src: '**/*.*'
        dest: 'dist/media/'

    processhtml:
      dist:
        options:
          process: true
        files:
          'dist/index.html': 'src/index.html'


    # !CSS Workflow
    sass:
      options:
        precision: 5
        sourcemap: true
      build:
        files: [{
          expand: true,
          cwd: 'src/css/',
          dest: '.tmp/css/',
          src: ['**/*.scss', '!_*.scss', '!modules/**/*.scss']
          ext: '.css',
        }]

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 9', '> 1%']
      build:
        expand: true
        flatten: true
        cwd: '.tmp/css/'
        src: '**/*.css'
        dest: '.tmp/css/'

    csslint:
      build:
        expand: true
        cwd: '.tmp/css'
        src: '**/*.css'

    cssmin:
      build:
        options:
          report: 'gzip'
          keepSpecialComments: 1
        files: [{
          expand: true
          cwd: '.tmp/css/'
          src: '**/*.css'
          dest: '.tmp/css-min/'
          ext: '.css'
        }]


    # !JS Workflow
    coffee:
      options:
        sourceMap: true
        bare: false
      build:
        expand: true
        flatten: true
        cwd: 'src/js'
        src: '**/*.coffee'
        dest: '.tmp/js/'
        ext: '.js'

    uglify:
      options:
        preserveComments: 'some'
        report: 'gzip'
        compress:
          global_defs:
            "DEBUG": false
          dead_code: true
      build:
        expand: true
        # flatten: true
        cwd: '.tmp/js/'
        src: '*.js'
        dest: 'dist/'


    # !Connect
    connect:
      build:
        options:
          port: 4000
          base: 'dev'
          livereload: true
      dist:
        options:
          port: 5000
          base: 'dist'
          livereload: true

    # !Watch
    watch:
      coffee:
        files: 'src/js/**/*.coffee'
        tasks: 'js'
      js:
        files: 'src/js/**/*.js'
        tasks: ['copy:js_raw', 'js']
      sass:
        files: 'src/css/**/*.scss'
        tasks: 'css'
      html:
        files: 'src/*.html'
        tasks: 'html'
      livereload:
        options:
          livereload: true
        files: ['dev/**/*']


    # !Load Tasks
    grunt.loadNpmTasks 'grunt-autoprefixer'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-csslint'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-shell'
    grunt.loadNpmTasks 'grunt-processhtml'

    # !Register Tasks
    grunt.registerTask 'default', ['shell', 'css', 'js', 'media', 'html', 'connect', 'watch']

    grunt.registerTask 'css', ['sass', 'autoprefixer', 'cssmin', 'copy_css']
    grunt.registerTask 'copy_css', ['copy:css', 'copy:cssdist']
    grunt.registerTask 'js', ['coffee', 'uglify', 'copy:js', 'copy:js_raw', 'copy:js_src_coffee']
    grunt.registerTask 'media', ['copy:media_dev', 'copy:media_dist']
    grunt.registerTask 'html', ['copy:htmldev', 'processhtml']
