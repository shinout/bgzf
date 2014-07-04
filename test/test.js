var bgzf = require('../index.js');

function run() {
  var defBuf = require("fs").readFileSync(__dirname + "/header");
  var delta = defBuf.readUInt16LE(16) + 1;
  var input = defBuf.slice(18, delta-8);
  var ret = bgzf.inflateRaw(input);
  console.log(ret.toString());
}

run()
