var gulp = require('gulp')
var inject = require('gulp-inject')
var sass = require('gulp-sass')
var path = require('path')
var bower = require('gulp-bower')
var bowerFiles = require('main-bower-files')
var react = require('gulp-react')
var watch = require('gulp-watch')
var plumber = require('gulp-plumber')
var jshint = require('gulp-jshint')
var shell = require('gulp-shell')

var bowerDir = './bower_components/' 
var sassSrcSpec = ['./styles/*.scss']
var jsLibSrcSpec = ['./lib/*.js']
var jsxSrcSpec = [
  './jsx/components.js',
  './jsx/about.js',
  './jsx/home.js',
  './jsx/demo.js',
  './jsx/app.js'
]
var htmlSrcSpec = ['./views/index.html']

function defaultBuild() {
  var css = gulp.src(sassSrcSpec)
    .pipe(plumber())
    .pipe(sass({
        includePaths: [
          bowerDir + 'bootstrap-sass-official/assets/stylesheets',
        ]
     }))
    .pipe(gulp.dest('./public/css'))

  var jsLibFiles = gulp.src(jsLibSrcSpec)
    .pipe(plumber())
    .pipe(gulp.dest('./public/js'))

  var jsxFilesSrc = gulp.src(jsxSrcSpec)
    .pipe(plumber())
    .pipe(react())
  jsxFilesSrc
    .pipe(jshint())
    .pipe(jshint.reporter('default'))
  var jsxFiles = jsxFilesSrc
    .pipe(gulp.dest('./public/js'))

  var bowerJs = gulp.src(bowerFiles(), {read: false})

  return gulp.src(htmlSrcSpec)
    .pipe(plumber())
    .pipe(inject(css))
    .pipe(inject(bowerJs, {name: 'bower'}))
    .pipe(inject(jsLibFiles, {name: 'lib'}))
    .pipe(inject(jsxFiles, {name: 'jsx'}))
    .pipe(gulp.dest('./public/html'))
}

gulp.task('bower', function () {
  return bower()
})

gulp.task('default', defaultBuild)

gulp.task('watch', function () {
  watch(sassSrcSpec.concat(jsxSrcSpec).concat(htmlSrcSpec).concat(jsLibSrcSpec), function () {
    return defaultBuild()
  })
})

gulp.task('chuck', function () {
  shell.task(['cd chuck/src && make -j5 emscripten'])
  return gulp.src('./chuck/src/chuck.js*')
    .pipe(gulp.dest('./public/js'))
})