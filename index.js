(function() {
  var BGZF_HEADER, bgzf, inflateRawSync;

  BGZF_HEADER = "1f 8b 08 04 00 00 00 00 00 ff 06 00 42 43 02 00".split(" ").map(function(v) {
    return parseInt(v, 16);
  });

  inflateRawSync = require('./build/Release/bgzf').inflateRawSync;

  bgzf = {};

  bgzf.inflateRaw = function(defbuf) {
    var len, ret;
    ret = new Buffer(65535);
    len = inflateRawSync(defbuf, ret);
    return ret.slice(0, len);
  };

  bgzf.inflate = function(input) {
    var buf, c, d_offsets, defbuf, defbufs, dsize, e, end, i, i_offsets, infbuf, isize, start, total_dsize, total_isize, _i, _j, _k, _len, _len1;
    for (_i = _j = 0, _len = BGZF_HEADER.length; _j < _len; _i = ++_j) {
      c = BGZF_HEADER[_i];
      if (c !== input[_i]) {
        throw new Error("not BGZF format");
      }
    }
    buf = input;
    defbufs = [];
    d_offsets = [];
    i_offsets = [];
    total_isize = 0;
    total_dsize = 0;
    try {
      while (true) {
        dsize = buf.readUInt16LE(16) + 1;
        isize = buf.readUInt32LE(dsize - 4);
        defbuf = buf.slice(18, dsize - 8);
        i_offsets.push(total_isize);
        d_offsets.push(total_dsize);
        defbufs.push(defbuf);
        total_isize += isize;
        total_dsize += dsize;
        buf = buf.slice(dsize);
      }
    } catch (_error) {
      e = _error;
    }
    d_offsets.push(total_dsize);
    i_offsets.push(total_isize);
    infbuf = new Buffer(total_isize);
    for (i = _k = 0, _len1 = defbufs.length; _k < _len1; i = ++_k) {
      defbuf = defbufs[i];
      start = i_offsets[i];
      end = i_offsets[i + 1];
      inflateRawSync(defbuf, infbuf.slice(start, end));
    }
    return [infbuf, i_offsets, d_offsets, buf];
  };

  module.exports = bgzf;

}).call(this);
