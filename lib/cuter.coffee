program = require 'commander'
fs = require 'fs'
path = require 'path'
calculator = require './tile-calculator'

run = () ->
  program
  .version('0.0.1')
  .usage('[options] <file1> <file2> <file...>')
  .option('-o, --output [path]', 'Set output directory [tiles]', 'tiles')
  .option('-s, --size [slice size]', 'Set slice size [256]', 256)
  .parse process.argv

  output = path.join process.cwd(), program.output
  # Creating output directory
  fs.mkdirSync output if not fs.existsSync output

module.exports.run = run