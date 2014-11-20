var gulp = require('gulp')
var inject = require('gulp-inject')
var sass = require('gulp-sass')
var path = require('path')
var bower = require('gulp-bower')
var bowerFiles = require('main-bower-files')
var react = require('gulp-react')
var watch = require('gulp-watch')
var plumber = require('gulp-plumber')

var bowerDir = './bower_components/' 

gulp.task('bower', function () {
  return bower()
})

gulp.task('default', function () {
  var css = watch('./stylesheets/*.scss')
    .pipe(plumber())
    .pipe(sass({
        includePaths: [
          bowerDir + 'bootstrap-sass-official/assets/stylesheets',
        ]
     }))
    .pipe(gulp.dest('./public/css'))
  var jsxFiles = watch(['./jsx/about.js', './jsx/home.js', './jsx/app.js'])
    .pipe(plumber())
    .pipe(react())
    .pipe(gulp.dest('./public/js'))
  var bowerJs = gulp.src(bowerFiles(), {read: false})
  watch('./views/index.html')
    .pipe(plumber())
    // Does not produce output - presumably because watch source hasn't ended its stream
    .pipe(inject(css))
    .pipe(inject(bowerJs, {name: 'bower'}))
    .pipe(inject(jsxFiles, {name: 'jsx'}))
    .pipe(gulp.dest('./public/html'))
})