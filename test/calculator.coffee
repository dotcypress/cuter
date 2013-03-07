assert = require 'assert'
calculator = require './../lib/tile-calculator'

describe 'Tile calculator', () ->

  it 'should calculate normalized image size', (done) ->
    result = calculator.calculateNormalizedSize 120, 99, 25
    assert.equal result.maxZoom, 5
    assert.equal result.width, 125
    assert.equal result.height, 100
    done()