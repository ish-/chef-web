gu          = require 'gulp'
coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
ngTplCache  = require 'gulp-angular-templatecache'
stylus      = require 'gulp-stylus'
jade        = require 'gulp-jade'
sq          = require 'streamqueue'
nib         = require 'nib'

PATH = do ->
  _src = './src/'
  _dist = './dist/'

  SRC: _src
  SRC_STYLES: _src + 'styles/'
  SRC_SCRIPTS: _src + 'scripts/'
  SRC_LIBS: _src + 'libs/'
  SRC_VIEWS: _src + 'views/'
  DEST: _dist

gu.task 'build:dev', ['index', 'js:dev', 'css', 'watch']

#########################
# INDEX.HTML            #
#########################

gu.task 'index', ->
  console.log process.argv.slice(-1)[0]
  gu.src PATH.SRC + 'index.jade'
    .pipe jade()
    .pipe gu.dest PATH.DEST

#########################
# JS                    #
#########################

scripts = ->
  gu.src([
    PATH.SRC_SCRIPTS + 'chef.coffee'
    PATH.SRC_SCRIPTS + '**/*.coffee'
  ]).pipe concat 'chef.coffee'
    .pipe coffee bare: no

vendorScripts = ->
  gu.src([
    PATH.SRC_LIBS + 'angular.js'
    PATH.SRC_LIBS + '**/*.js'
    '!' + PATH.SRC_LIBS + '**/_*'
  ]).pipe concat 'vendor.js'

ngTpl = ->
  gu.src PATH.SRC_VIEWS + '**/*.jade'
    .pipe jade()
    .pipe ngTplCache module: 'chef'

jsStream = ->
  s = sq objectMode: yes
    .queue scripts()
    .queue vendorScripts()
    .queue ngTpl()
    .done()

gu.task 'js:dev', ->
  jsStream()
    .pipe gu.dest PATH.DEST + 'js/'

gu.task 'js', ->
  jsStream()
    .pipe concat 'chef.js'
    .pipe gu.dest PATH.DEST + 'js/'
  # scripts().pipe gu.dest PATH.DEST
  # vendorScripts().pipe gu.dest PATH.DEST
  # ngTpl().pipe gu.dest PATH.DEST

#########################
# CSS                   #
#########################

bootstrap = ->
  gu.src PATH.SRC_STYLES + 'bootstrap/**/*'

styles = ->
  gu.src PATH.SRC_STYLES + '**/*.styl'
    .pipe stylus use: [nib()], filename: 'main.css'

gu.task 'css', ->
  styles().pipe gu.dest PATH.DEST + 'style/'
  bootstrap().pipe gu.dest PATH.DEST + 'style/bootstrap/'

#########################
# WATCH                 #
#########################

gu.task 'watch', ->
  gu.watch PATH.SRC_STYLES + '**/*', ['css']
  gu.watch [PATH.SRC_SCRIPTS + '**/*', PATH.SRC_VIEWS + '**/*'], ['js:dev']
  gu.watch PATH.SRC + 'index.jade', ['index']