gulp = require 'gulp'
del = require 'del'
bower = require 'gulp-bower'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
cond   = require 'gulp-if'
gutil = require 'gulp-util'

bases =
  dist: "dist/"

isRelease = gutil.env.release || false

gulp.task 'clean', ->
  del ['.tmp', 'dist']

gulp.task 'build', ->
  gulp.src(['lib/**/*', '*.html', 'css/**/*', 'js/**/*'], {base: "."})
    .pipe (gulp.dest 'dist')

gulp.task 'bower', ->
  bower()
    .pipe cond isRelease, uglify({preserveComments:'some'})
    .pipe flatten()
    .pipe (gulp.dest 'lib')
