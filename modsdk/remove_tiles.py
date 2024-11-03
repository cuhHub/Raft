import os
tile_dir = "C:/Program Files (x86)/Steam/steamapps/common/Stormworks/rom/data/tiles"
mod_tile_dir = "data/tiles"
tiles: dict[str, str] = {}

for tile in os.listdir(tile_dir):
    if tile.endswith(".bin"):
        file_name = os.path.splitext(tile)[0].removesuffix("_map_geometry") + ".xml"
        path = os.path.join(tile_dir, file_name)
        
        if not os.path.exists(path):
            continue
        
        with open(os.path.join(tile_dir, file_name), "r") as file:
            tiles[file_name.removesuffix(".xml")] = file.read()
        
empty_tile = """<?xml version="1.0" encoding="UTF-8"?>
<definition is_island="true">
    <meshes/>
    <physics_objects/>
    <physics_meshes/>
    </physics_meshes>
    <physics_dynamics/>
    <lights_omni/>
    <lights_spot/>
    <lights_tube/>
    <screens/>
    <edit_areas/>
    <interactables/>
    <door_logic_nodes/>
    <light_logic_nodes/>
    <rotation_logic_nodes/>
    <hangar_door_logic_nodes/>
    <audio_logic_nodes/>
    <tile_markers/>
    <mission_zones/>
    <dynamic_markers/>
    <ladders/>
    <perches/>
    <fires/>
    <train_tracks/>
    <volcano_markers/>
    <mineral_rocks/>
</definition>"""

empty_tile_definitions = """<?xml version="1.0" encoding="UTF-8"?>
<Trees/>
"""
        
for name, tile in tiles.items():
    tile_path = os.path.join(mod_tile_dir, name + ".xml")
    tile_definitions_path = os.path.join(mod_tile_dir, name + "_instances.xml")
    
    with open(tile_path, "w") as file:
        file.write(empty_tile)
        
    with open(tile_definitions_path, "w") as file:
        file.write(empty_tile_definitions)