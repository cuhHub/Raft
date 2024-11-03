py combine.py --directory "src/addon" --destination "src/addon/script.lua" --allow_file_extension ".lua"
py sync.py --directory "src/addon/script.lua" --destination "%appdata%/Stormworks/data/missions/Raft/"
py sync.py --directory "src/mod" --destination "%appdata%/Stormworks/data/mods/Raft"