module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    coffee:
      compile:
        files:
          "index.js": "src/index.coffee"
    shell:
      gyp:
        command: "node-gyp rebuild"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-shell"
  grunt.registerTask "default", ["coffee", "shell"]
