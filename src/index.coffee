BGZF_HEADER = "1f 8b 08 04 00 00 00 00 00 ff 06 00 42 43 02 00".split(" ").map (v)-> parseInt(v, 16)

inflateRawSync = require('./build/Release/bgzf').inflateRawSync
bgzf = {}

bgzf.inflateRaw = (defbuf)->
  ret = new Buffer(65535)
  len = inflateRawSync(defbuf, ret)
  return ret.slice(0, len)


bgzf.inflate = (input)->
  # check header
  throw new Error("not BGZF format") for c,_i in BGZF_HEADER when c isnt input[_i]
  buf = input
  defbufs = []
  d_offsets = []
  i_offsets = []
  total_isize = 0
  total_dsize = 0
  try
    loop
      dsize = buf.readUInt16LE(16) + 1
      isize = buf.readUInt32LE(dsize - 4)
      defbuf = buf.slice(18, dsize - 8)

      i_offsets.push total_isize
      d_offsets.push total_dsize
      defbufs.push defbuf

      total_isize += isize
      total_dsize += dsize
      buf = buf.slice dsize
  catch e
  d_offsets.push total_dsize
  i_offsets.push total_isize

  infbuf = new Buffer(total_isize)
  
  for defbuf,i in defbufs
    start = i_offsets[i]
    end   = i_offsets[i+1]
    inflateRawSync(defbuf, infbuf.slice(start, end))

  return [infbuf, i_offsets, d_offsets, buf]

module.exports = bgzf
