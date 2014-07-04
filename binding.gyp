{
  "targets": [
    {
      "target_name": "bgzf",
      "sources": [
        "src/bgzf.cc"
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"],
      "link_settings": {
        "libraries": [
          "-lz"
        ]
      }
    }
  ]
}
