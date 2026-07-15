solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "deps_file": "DEPS",
    "managed": False,
    "custom_deps": {
      "src/third_party/devtools-node-modules": None,
      "src/third_party/ffmpeg": None,
    },
    "custom_vars": {},
  },
]
target_os = ["ios"]
