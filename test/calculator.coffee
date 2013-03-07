assert = require 'assert'
calculator = require './../lib/tile-calculator'

describe 'Tile calculator', () ->

  it 'should calculate normalized image size', (done) ->
    result = calculator.calculateNormalizedSize 120, 99, 25
    assert.equal result.width, 125, 'Normalized width is invalid'
    assert.equal result.height, 100, 'Normalized height is invalid'
    done()