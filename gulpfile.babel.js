'use strict';

let gulp          = require('gulp');
let mkdirp        = require('mkdirp');
let del           = require('del');
let bower         = require('gulp-bower');
let uglify        = require('gulp-uglify');
let gutil         = require('gulp-util');
let runSequence   = require('run-sequence');
let merge         = require('merge');
let fs            = require('fs');
let rename        = require('gulp-rename');
let tap           = require('gulp-tap');
let path          = require('path');
let marked        = require('marked');
let htmlmin       = require('gulp-htmlmin');
let webserver     = require('gulp-webserver');
let webpack       = require('webpack');
let webpackConfig = require("./webpack.config");
let webpackProd   = require("./webpack.config.production");
let striptags     = require('striptags');
let build         = require("./build");

gulp.task('clean', () => {
  return del(['.tmp', 'dist']);
});

gulp.task('build:misc', () => {
  return gulp.src(['favicon/**/*', '*.html', 'css/**/*', 'js/**/*'], {base: "."})
    .pipe(gulp.dest('dist'))
});

gulp.task('compress', ['compress:html'])

gulp.task('compress:html', () => {
  return gulp.src('dist/**/*.html', {base: "."})
    .pipe(htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest('.'));
});

gulp.task('bower', () => {
  return bower();
});

gulp.task('default', () => {
  return runSequence('clean', 'bower', 'build', 'webpack', 'serve');
});

gulp.task('deploy', () => {
    return runSequence('clean', 'bower', 'build', 'compress', 'webpack:prod');
  }
);

let _webpack = (config, callback) => {
  return webpack(config, (err, stats) => {
    if(err)
      throw new gutil.PluginError("webpack:build", err);
    gutil.log("[webpack:build]", stats.toString({
      colors: true
    }));
    return callback();
    }
  )
};

gulp.task('webpack', (callback) => {
  let myConfig = Object.create(webpackConfig);
  return _webpack(myConfig, callback);
});

gulp.task('webpack:prod', (callback) => {
  let myConfig = Object.create(webpackProd);
  return _webpack(myConfig, callback);
});


gulp.task('serve', () => {
  gulp.watch(['./templates/**/*.jade', './articles/**/*.md'], () => {
    runSequence('build', 'compress');
  });
  gulp.watch(['./app/**/*',  './sass/**/*.sass'], () => {
    runSequence('webpack');
  });
  gulp.src('dist')
    .pipe(webserver({
      livereload: true,
      proxies:[{
        source: '/bucket',
        target: 'http://minamorl.com/bucket'
        }]
    })
    );
});

gulp.task('build', ['build:misc', 'build:articles', 'build:index']);

gulp.task('build:articles', () => {
  build.build_articles()
});

gulp.task('build:index', () => {
  build.build_index()
});
