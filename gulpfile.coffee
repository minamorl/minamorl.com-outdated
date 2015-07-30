gulp        = require 'gulp'
del         = require 'del'
bower       = require 'gulp-bower'
flatten     = require 'gulp-flatten'
uglify      = require 'gulp-uglify'
cond        = require 'gulp-if'
gutil       = require 'gulp-util'
sass        = require 'gulp-sass'
runSequence = require 'run-sequence'
merge       = require 'merge'
frontMatter = require 'gulp-front-matter'
layout      = require 'gulp-layout'
markdown    = require 'gulp-markdown'
jade        = require 'gulp-jade'
fs          = require 'fs'
rename      = require 'gulp-rename'
tap         = require 'gulp-tap'
path = require 'path'

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


gulp.task 'markdown', ->
  defaultLayout =
    layout: "templates/article.jade"
  merged = {}
  gulp.src 'articles/**/*.md'
    .pipe frontMatter()
    .pipe markdown()
    .pipe layout ((file) ->
      merge(defaultLayout, file.frontMatter)
    )
    .pipe tap((file) ->
      console.log file.path
      extname = path.extname(path)
      name =
        dirname:  path.dirname(file.path),
        basename: path.basename(file.path, extname),
      file.path = path.join name.dirname, file.frontMatter.timestamp + "-" + name.basename
      console.log file.path
    )
    .pipe gulp.dest('./dist/articles')

gulp.task 'update-index', ->
  dir = fs.readdir 'dist/articles', (err, filenames)->
    gulp.src 'templates/index.jade'
      .pipe jade
        locals:
          dir: filenames
      .pipe gulp.dest('./dist')
