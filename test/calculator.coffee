assert = require 'assert'
calculator = require './../lib/tile-calculator'

describe 'Tile calculator', () ->

  it 'should calculate normalized image size', (done) ->
    result = calculator.calculateNormalizedSize 120, 99, 25
    assert.equal result.width, 125
    assert.equal result.height, 100
    done()

  it 'should calculate max zoom', (done) ->
    result = calculator.calculateMaxZoom 120, 101, 25
    assert.equal result, 3
    done()