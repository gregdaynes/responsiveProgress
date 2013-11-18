module.exports = (grunt) ->

	grunt.initConfig
    # !General Filesystem
	  shell:
	    build:
        command: 'rm -rf _dev _dist _tmp'

    copy:
      css:
        expand: true
        cwd: '_tmp/css/'
        src: ['**/*.css', '**/*.map', '!min/**/*.*']
        dest: '_dev/'
      css_dist:
        expand: true
        cwd: '_tmp/css-min/'
        src: '**/*.css'
        dest: '_dist/'
      js:
        expand: true
        cwd: '_tmp/js/'
        src: '**/*.*'
        dest: '_dev/'
      js_raw:
        expand: true
        cwd: 'assets/js/'
        src: '**/*.js'
        dest: '_dev/'
      html_dev:
        expand: true
        cwd: ''
        src: '*.html'
        dest: '_dev/'
      html_dist:
        expand: true
        cwd: ''
        src: '*.html'
        dest: '_dist/'

    processhtml:
      dist:
        options:
          process: true
        files:
          '_dist/index.html': 'index.html'


    # !CSS Workflow
    sass:
      options:
        precision: 5
        sourcemap: true
      build:
        files: [{
          expand: true,
          cwd: 'assets/css/',
          dest: '_tmp/css/',
          src: ['**/*.scss'],
          ext: '.css',
        }]

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 9', '> 1%']
      build:
        expand: true
        flatten: true
        cwd: '_tmp/css/'
        src: '**/*.css'
        dest: '_tmp/css/'

    csslint:
      build:
        expand: true
        cwd: '_tmp/css'
        src: '**/*.css'

    cssmin:
      build:
        options:
          report: 'gzip'
          keepSpecialComments: 1
        files: [{
          expand: true
          cwd: '_tmp/css/'
          src: '**/*.css'
          dest: '_tmp/css-min/'
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
        cwd: 'assets/js'
        src: '**/*.coffee'
        dest: '_tmp/js/'
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
        cwd: '_tmp/js/'
        src: '*.js'
        dest: '_dist/'


    # !Connect
    connect:
      build:
        options:
          port: 4000
          base: '_dev'
          livereload: true
      dist:
        options:
          port: 5000
          base: '_dist'
          livereload: true

    # !Watch
    watch:
      coffee:
        files: 'assets/js/**/*.coffee'
        tasks: 'js'
      js:
        files: 'assets/js/**/*.js'
        tasks: ['copy:js_raw', 'js']
      sass:
        files: 'assets/css/**/*.scss'
        tasks: 'css'
      html:
        files: '*.html'
        tasks: 'html'
      livereload:
        options:
          livereload: true
        files: ['_dev/**/*']


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
    grunt.registerTask 'default', ['shell', 'css', 'js', 'html', 'connect', 'watch']

    grunt.registerTask 'css', ['sass', 'autoprefixer', 'csslint', 'cssmin', 'copy_css']
    grunt.registerTask 'copy_css', ['copy:css', 'copy:css_dist']
    grunt.registerTask 'js', ['coffee', 'uglify', 'copy:js', 'copy:js_raw']
    grunt.registerTask 'html', ['copy:html_dev', 'processhtml']