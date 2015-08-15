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
yamlFront   = require 'yaml-front-matter'
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

gulp.task 'build:misc', ->
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

gulp.task 'default', ->
  runSequence 'clean', 'bower', 'sass', 'build', 'serve'

gulp.task 'deploy', ->
  runSequence 'clean', 'bower', 'sass', 'build', 'compress'

gulp.task 'build', ['build:misc', 'build:articles', 'build:index']

gulp.task 'build:articles', ->
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
      extname = path.extname(path)
      name =
        dirname:  path.dirname(file.path),
        basename: path.basename(file.path, extname),
      file.path = path.join name.dirname, file.frontMatter.timestamp + "-" + name.basename
    )
    .pipe gulp.dest('./dist/articles')

gulp.task 'build:index', ->
  defaultLayout =
    layout: "templates/index.jade"
  fs.readdir 'articles', (err, markdown_filenames) ->
    parsed = []
    for filename in markdown_filenames
      parsed.push
        filename: filename
        yaml: yamlFront.loadFront (fs.readFileSync 'articles/' + filename)

    parsed.sort (a, b) ->
      if a.yaml.timestamp < b.yaml.timestamp
        return 1
      if a.yaml.timestamp > b.yaml.timestamp
        return -1
      return 0

    newest = parsed[0].filename

    gulp.src "articles/" + newest
      .pipe frontMatter()
      .pipe markdown()
      .pipe layout ((file) ->
        merge(defaultLayout, file.frontMatter, {dir: parsed}))
      .pipe rename (path) ->
        path.basename = "index"
      .pipe gulp.dest('./dist')

gulp.task 'serve', ->
  gulp.watch './sass/**/*.sass', ['sass']
  gulp.watch ['./templates/**/*.jade', './articles/**/*.md'], ['build']
  gulp.src 'dist'
    .pipe webserver
      livereload: true,
      proxies:[
        source: '/bucket',
        target: 'http://minamorl.com/bucket',
      ]
