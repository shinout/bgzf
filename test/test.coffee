bgzf = require('../index.js')
fs = require("fs")

run = ->
  READ_SIZE = 100000
  filename = __dirname + "/large.bam"
  fd = fs.openSync(filename, "r")
  filesize = fs.statSync(filename).size

  d_offset = 0
  while filesize > d_offset
    size = Math.min READ_SIZE, filesize - d_offset
    buf = new Buffer(size)
    fs.readSync fd, buf, 0, size, d_offset
    [infbuf, i_offsets, d_offsets] = bgzf.inflate buf
    d_offset += d_offsets[d_offsets.length - 1]
    console.log d_offset

run()
