fs     = require 'fs'
{exec} = require 'child_process'
util   = require 'util'

binDir = "./node_modules/.bin/"

task 'watch', 'Watch for changes in coffee files to build and test', ->
    util.log "Watching for changes in src and spec"
    lastTest = 0
    watchDir 'src', ->
      invoke 'build:src'
      invoke 'build:min'
      invoke 'build:doc'
      invoke 'build:spec'
    watchDir 'spec-coffee', ->
      invoke 'build:spec'
    watchDir 'spec', (file)->
      # We only want to run tests once (a second),
      # even if a bunch of test files change
      time = new Date().getTime()
      if (time - lastTest) > 1000
        lastTest = time
        invoke 'spec'

task 'spec', 'Run the specs', ->
  util.log "Running specs..."
  exec "jasmine --no-color", (err, stdout, stderr) ->
    if err
      handleError(parseTestResults(stdout), stderr)
    else
      displayNotification "Tests pass!"
      util.log lastLine(stdout)

task 'build', 'Build source and specs', ->
  invoke 'build:src'
  invoke 'build:min'
  invoke 'build:spec'

task 'build:src', 'Build the src files into lib', ->
  util.log "Compiling src..."
  exec binDir + "coffee -o lib/ -c src/", (err, stdout, stderr) ->
    handleError(err) if err

task 'build:min', 'Build the minified files into lib', ->
  util.log "Minify src..."
  exec binDir + "uglifyjs -m --comments all -o lib/stomp.min.js lib/stomp.js", (err, stdout, stderr) ->
    handleError(err) if err

task 'build:doc', 'Build docco documentation', ->
  util.log "Building doc..."
  exec binDir + "docco -o doc/ src/*.coffee", (err, stdout, stderr) ->
    handleError(err) if err

task 'build:spec', 'Build the spec files into dist/spec', ->
  util.log "Compiling spec..."
  exec binDir + "coffee -o spec/ -c spec-coffee/", (err, stdout, stderr) ->
    handleError(err) if err

watchDir = (dir, callback) ->
  fs.readdir dir, (err, files) ->
      handleError(err) if err
      for file in files then do (file) ->
          fs.watchFile "#{dir}/#{file}", (curr, prev) ->
              if +curr.mtime isnt +prev.mtime
                  callback "#{dir}/#{file}"

parseTestResults = (data) ->
  lines = (line for line in data.split('\n') when line.length > 5)
  results = lines.pop()
  details = lines[1...lines.length-2].join('\n')
  results + '\n\n' + details + '\n'

lastLine = (data) ->
  (line for line in data.split('\n') when line.length > 5).pop()

handleError = (error, stderr) ->
  if stderr? and !error
    util.log stderr
    displayNotification stderr.match(/\n(Error:[^\n]+)/)?[1]
  else
    util.log error
    displayNotification error

displayNotification = (message = '') ->
  options = { title: 'CoffeeScript' }
  try require('growl').notify message, options
