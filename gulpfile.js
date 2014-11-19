var gulp = require('gulp')
var inject = require('gulp-inject')
var sass = require('gulp-sass')
var path = require('path')
var bower = require('gulp-bower')
var bowerFiles = require('main-bower-files')

var bowerDir = './bower_components/' 

gulp.task('bower', function () {
  return bower()
})

gulp.task('default', function () {
  var css = gulp.src('./stylesheets/*.scss')
    .pipe(sass({
        includePaths: [
          bowerDir + 'bootstrap-sass-official/assets/stylesheets',
        ]
     }))
    .pipe(gulp.dest('./public/css'))
  var bowerJs = gulp.src(bowerFiles(), {read: false})
  gulp.src('./views/index.html')
    .pipe(inject(css))
    .pipe(inject(bowerJs), {name: 'bower'})
    .pipe(gulp.dest('./public/html'))
})