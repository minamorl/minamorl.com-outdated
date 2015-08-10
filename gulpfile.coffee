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
path        = require 'path'
marked      = require 'marked'
git         = require 'gulp-git'
htmlmin     = require 'gulp-htmlmin'
cssmin      = require 'gulp-minify-css'
webserver   = require 'gulp-webserver'

gulp.task 'clean', ->
  del ['.tmp', 'dist']

gulp.task 'build', ->
  gulp.src(['lib/**/*', '*.html', 'css/**/*', 'js/**/*'], {base: "."})
    .pipe (gulp.dest 'dist')

gulp.task 'compress', ['compress:html', 'compress:css']

gulp.task 'compress:html', ->
  gulp.src 'dist/**/*.html', {base: "."}
    .pipe htmlmin({collapseWhitespace: true})
    .pipe (gulp.dest '.')

gulp.task 'compress:css', ->
  gulp.src 'dist/**/*.css', {base: "."}
    .pipe cssmin()
    .pipe (gulp.dest '.')

gulp.task 'bower', ->
  bower()
    .pipe flatten()
    .pipe (gulp.dest 'lib')

gulp.task 'sass', ->
  gulp.src('./sass/**/*.sass')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./dist/css'))

gulp.task 'watch', ->
  gulp.watch ['sass/**/*.scss'], ['sass']

gulp.task 'default', ->
  runSequence 'clean', 'bower', 'sass', 'markdown', 'update-index', 'build', 'compress', 'deploy'

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
  defaultLayout =
    layout: "templates/index.jade"
  fs.readdir 'dist/articles', (err, filenames) ->

    filenames.sort (a, b) ->
      if a < b
        return 1
      if a > b
        return -1
      return 0

    newest = filenames[0].replace('.html', '.md')
    newest = newest.split("+0900-")
    newest = newest[newest.length-1]
    newest = path.resolve(__dirname, "articles",  newest)

    console.log newest

    gulp.src newest
      .pipe frontMatter()
      .pipe markdown()
      .pipe layout ((file) ->
        merge(defaultLayout, file.frontMatter, {dir: filenames}))
      .pipe rename (path) ->
        path.basename = "index"
      .pipe gulp.dest('./dist')

gulp.task 'deploy', ->
  runSequence 'git-add'

gulp.task 'git-add', ->
  gulp.src ['./articles/**/*.md', './dist/**/*']

gulp.task 'webserver', ->
  gulp.watch './sass/**/*.sass', ['sass']

  gulp.src 'dist'
    .pipe webserver
      livereload: true,
      proxies:[
        source: '/bucket',
        target: 'http://minamorl.com/bucket',
      ]

