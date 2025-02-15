package handle_maps

import "core:mem"
import rl "vendor:raylib" // Raylib bindings
import "core:fmt"

MAP_HEIGHT: i32
MAP_WIDTH: i32

MAP_SIZE: string

//Set Map Size
map_size :: proc()
{
    if MAP_SIZE == "LARGE"
    {
        MAP_HEIGHT = 50
        MAP_WIDTH = 100
    } else if MAP_SIZE == "MEDIUM"
    {
        MAP_HEIGHT = 30
        MAP_WIDTH = 60
    } else
    {
        MAP_HEIGHT = 10
        MAP_WIDTH = 20
    }
}

// Tile Type Enum
Tile_Type :: enum {
    Grass,
    Water,
    Mountain,
}

// Tile Structure
Tile :: struct {
    id: int,
    type: Tile_Type,
    position: rl.Vector2,
    texture: rl.Texture2D, // Reference to texture
}

// Handle Map for Tiles
Tile_Map :: struct {
    tiles: Handle_Map(Tile),
}

// World Struct Containing the Tile Map
World_Map :: struct {
    tile_map: Tile_Map,
    tile_size: int,
    visible: bool,
}

Tile_Textures :: struct {
    grass: rl.Texture2D,
    water: rl.Texture2D,
    mountain: rl.Texture2D,
}

// Initialize Tile Map
init_tile_map :: proc(maps: ^Tile_Map, allocator := context.allocator) {
    init(&maps.tiles, allocator)
}

// Destroy Tile Map
destroy_tile_map :: proc(maps: ^Tile_Map) {
    destroy(&maps.tiles)
}

// Load Textures for Tiles
load_tile_textures :: proc() -> Tile_Textures {
    return Tile_Textures{
    grass = rl.LoadTexture("assets/grass.png"),
    water = rl.LoadTexture("assets/water.png"),
    mountain = rl.LoadTexture("assets/mountain.png"),
    }
}


// Populate the Tile Map with Example Data
populate_tile_map :: proc(world: ^World_Map, tile_textures: Tile_Textures) {
    world.tile_size = 32

    for y := 0; y < 10; y += 1 {
        for x := 0; x < 10; x += 1 {
            tile_type: Tile_Type
            texture: rl.Texture2D

            if (x + y) % 3 == 0 {
                tile_type = Tile_Type.Grass
            } else if (x + y) % 3 == 1 {
                tile_type = Tile_Type.Water
            } else {
                tile_type = Tile_Type.Mountain
            }

            if tile_type == Tile_Type.Grass {
                texture = tile_textures.grass
            } else if tile_type == Tile_Type.Water {
                texture = tile_textures.water
            } else {
                texture = tile_textures.mountain
            }

            tile := Tile{
                id = x + y * 10,
                type = tile_type,
                position = rl.Vector2{f32(x * world.tile_size), f32(y * world.tile_size)},
                texture = texture,
            }

            _ = insert(&world.tile_map.tiles, tile)
        }
    }
}

render_tile_map :: proc(world: ^World_Map) {
    if !world.visible {
        return
    }

    for handle, _ in world.tile_map.tiles.handles {
        tile_ptr, ok := get(&world.tile_map.tiles, handle)
        if ok && tile_ptr != nil {
            tile := tile_ptr^
            rl.DrawTextureV(tile.texture, tile.position, rl.WHITE)
        }
    }
}

toggle_tile_rendering :: proc(world: ^World_Map) {
    world.visible = !world.visible
}