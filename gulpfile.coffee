gulp          = require 'gulp'
del           = require 'del'
bower         = require 'gulp-bower'
uglify        = require 'gulp-uglify'
cond          = require 'gulp-if'
gutil         = require 'gulp-util'
sass          = require 'gulp-sass'
runSequence   = require 'run-sequence'
merge         = require 'merge'
frontMatter   = require 'gulp-front-matter'
yamlFront     = require 'yaml-front-matter'
layout        = require 'gulp-layout'
markdown      = require 'gulp-markdown'
jade          = require 'gulp-jade'
fs            = require 'fs'
rename        = require 'gulp-rename'
tap           = require 'gulp-tap'
path          = require 'path'
marked        = require 'marked'
git           = require 'gulp-git'
htmlmin       = require 'gulp-htmlmin'
cssmin        = require 'gulp-minify-css'
webserver     = require 'gulp-webserver'
webpack       = require 'webpack'
webpackConfig = require "./webpack.config.coffee"
cheerio       = require 'cheerio'


gulp.task 'clean', ->
  del ['.tmp', 'dist']

gulp.task 'build:misc', ->
  gulp.src(['*.html', 'css/**/*', 'js/**/*'], {base: "."})
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

gulp.task 'default', ->
  runSequence 'clean', 'bower', 'build', 'webpack', 'serve'

gulp.task 'deploy', ->
  runSequence 'clean', 'bower', 'build', 'compress', 'webpack'

gulp.task 'webpack', (callback) ->
  myConfig = Object.create(webpackConfig)
  webpack(myConfig, (err, stats) ->
    if(err)
      throw new gutil.PluginError("webpack:build", err)
    gutil.log("[webpack:build]", stats.toString({
      colors: true
    }))
    callback()
  )

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
        dirname  : path.dirname(file.path),
        basename : path.basename(file.path, extname),
      file.path = path.join name.dirname, file.frontMatter.timestamp + "-" + name.basename
    )
    .pipe gulp.dest('./dist/articles')

gulp.task 'build:index', ->
  defaultLayout =
    layout: "templates/index.jade"
  fs.readdir 'articles', (err, markdown_filenames) ->
    parsed = []
    for filename in markdown_filenames
      yaml = yamlFront.loadFront (fs.readFileSync 'articles/' + filename)
      parsed.push
        filename: filename
        target: "articles/" + yaml.timestamp + "-" + filename.replace('.md', '.html')
        yaml: yaml

    _by_timestamp = (a, b) ->
      if a.yaml.timestamp < b.yaml.timestamp
        return 1
      if a.yaml.timestamp > b.yaml.timestamp
        return -1
      return 0

    parsed.sort _by_timestamp

    first_three_tags = (str) ->
      $ = cheerio.load(str)
      console.log $.root().children()
      return $.root().children().slice(0,2)


    gulp.src "./templates/index.jade"
      .pipe jade
        locals:
          dir: parsed,
          marked: marked,
          first_three_tags: first_three_tags
      .pipe gulp.dest('./dist')

gulp.task 'serve', ->
  gulp.watch ['./templates/**/*.jade', './articles/**/*.md'], ->
    runSequence 'build', 'compress'
  gulp.watch ['./app/**/*',  './sass/**/*.sass'], ->
    runSequence 'webpack'
  gulp.src 'dist'
    .pipe webserver
      livereload: true,
      proxies:[
        source: '/bucket',
        target: 'http://minamorl.com/bucket'
      ]
