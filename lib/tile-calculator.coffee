module.exports.calculateNormalizedSize = (width, height, tileSize) ->
  rows = Math.floor width / tileSize
  columns = Math.floor height / tileSize
  columns = columns + 1 if width / tileSize > 0
  rows = rows + 1 if height / tileSize > 0
  {width: rows * tileSize, height: columns * tileSize}