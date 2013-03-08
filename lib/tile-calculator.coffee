module.exports.calculateNormalizedSize = (width, height, tileSize) ->
  columns = Math.floor width / tileSize
  columns = columns + 1 if width / tileSize > 0
  rows = Math.floor height / tileSize
  rows = rows + 1 if height / tileSize > 0
  width: columns * tileSize, height: rows * tileSize, columns: columns, rows: rows

module.exports.calculateMaxZoom = (width, height, tileSize) ->
  min = Math.min width, height
  Math.ceil Math.sqrt min / tileSize