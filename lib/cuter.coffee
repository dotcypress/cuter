program = require 'commander'
fs = require 'fs'
path = require 'path'
gm = require 'gm'
_ = require 'underscore'
async = require 'async'
rimraf = require 'rimraf'
calculator = require './tile-calculator'

slice = (file, options, cb) ->
  filePath = path.join process.cwd(), file
  sliceDir = "#{program.output}/#{path.basename file, path.extname file}"
  fs.mkdirSync sliceDir
  gm(file).size (err, originalSize) ->
    return cb err if err
    maxZoom = calculator.calculateMaxZoom(originalSize.width, originalSize.height, options.size) + 1
    cutTasks = _.map (_.range 1, maxZoom), (zoom) ->
      (cb) ->
        level = maxZoom - zoom
        zoomedSize =
          width: originalSize.width / Math.pow level, 2
          height: originalSize.height / Math.pow level, 2
        zoomedFile = "#{program.output}/origin/#{path.basename file}.#{zoom}"
        gm(filePath)
          .resize(zoomedSize.width, zoomedSize.height)
          .write zoomedFile, (err) ->
            return cb err if err
            cut zoomedFile, sliceDir, zoom, options, cb
    async.parallel cutTasks, cb

cut = (file, sliceDir, zoom, options, cb) ->
  normalizeImageSize file, options, (err, measurement) ->
    cb err if err
    tiles = []
    fs.mkdirSync "#{sliceDir}/#{zoom}"
    for column in [0..measurement.columns - 1]
      fs.mkdirSync "#{sliceDir}/#{zoom}/#{column}"
      for row in [0..measurement.rows - 1]
        tiles.push {x: column, y: row}
    cropTasks = _.map tiles, (tile) ->
      (cb) ->
        crop tile, file, "#{sliceDir}/#{zoom}/#{tile.x}/#{tile.y}.jpg", options, cb
    async.series cropTasks, cb

normalizeImageSize = (file, options, cb) ->
  gm(file).size (err, result) ->
    return cb err if err
    newSize = calculator.calculateNormalizedSize result.width, result.height, options.size
    gm(file)
      .background("##{options.background}")
      .extent(newSize.width, newSize.height)
      .write file, (err) -> cb err, newSize

crop = (tile, file, outputFile, options, cb) ->
  gm(file)
    .crop(options.size, options.size, tile.x * options.size, tile.y * options.size)
    .write outputFile, (err) -> cb err, file

run = () ->
  program
    .version('0.0.1')
    .usage('[options] <file1> <file2> <file...>')
    .option('-o, --output [path]', 'Set output directory [tiles]', 'tiles')
    .option('-s, --size [slice size]', 'Set slice size [250]', 256)
    .option('-b, --background [color]', 'Background color [ffffff]', 'ffffff')
    .parse process.argv

  if program.args.length == 0
    program.outputHelp()
    return

  program.output = path.join process.cwd(), program.output

  rimraf program.output, (err) ->
    fs.mkdirSync program.output
    fs.mkdirSync "#{program.output}/origin"

    sliceTasks = _.map program.args, (file) -> (cb) -> slice file, program, cb
    async.parallel sliceTasks, (err, results) ->
      if err
        console.log err
        return

module.exports.run = run