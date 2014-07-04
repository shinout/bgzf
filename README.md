BGZF
==================
inflates BGZF written in C++

installation
----------------
```bash
$ npm install bgzf
```

usage
-----------
```js
var bgzf = require("bgzf");
var bam = require("fs").readFileSync("/path/to/bamfile.bam");
var result = bgzf.inflate(bam);
var inflated = result[0]; // inflated buffer
var d_offsets = result[1]; // offsets of each BGZF
var i_offsets = result[2]; // offsets of each BGZF in the inflated buffer
var remainder = result[3]; // unparsed buffer (rightmost side of the given buffer)
```
