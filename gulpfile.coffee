gulp = require 'gulp'
bower = require 'gulp-bower'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
cond   = require 'gulp-if'
gutil = require 'gulp-util'

isRelease = gutil.env.release || false
gulp.task 'bower', ->
  bower()
    .pipe cond isRelease, uglify({preserveComments:'some'})
    .pipe flatten()
    .pipe (gulp.dest 'lib')
