gulp        = require 'gulp'
del         = require 'del'
bower       = require 'gulp-bower'
flatten     = require 'gulp-flatten'
uglify      = require 'gulp-uglify'
cond        = require 'gulp-if'
gutil       = require 'gulp-util'
sass        = require 'gulp-sass'
runSequence = require 'run-sequence'

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

gulp.task 'sass', ->
  gulp.src('./sass/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'))

gulp.task 'watch', ->
  gulp.watch ['sass/**/*.scss'], ['sass']

gulp.task 'default', ->
  runSequence 'clean', 'bower', 'sass', 'build'
