#+feature dynamic-literals
package main

import rl "vendor:raylib"
import "core:math"
import "core:math/rand"
import "core:fmt"
import "base:builtin"
import ham "data/handle_maps"
import "data/kingdom_processing"
import "vendor:sdl2"
import "core:os"



WINDOW_WIDTH :: 1920
WINDOW_HEIGHT:: 1080


GLOBAL_SEED: i32

KINGDOM_COUNT: i32
KINGDOM_LIST: []i32

EXIT_WINDOW_REQUESTED: bool
EXIT_WINDOW: bool

is_paused: bool = false

camera_speed: f32 = 0.2
mouse_edge_scroll_speed: f32 = 0.1
screen_margin: i32 = 20 // Edge detection margin in pixels
rotation_angle := 0.0
rotation_step := 90.0 // Rotation angle step

main :: proc()
{
	seed_generation()

	// Initialize and run debug scripts for all handle maps
	//maps: ham.All_Static_Maps
    //ham.init_all_maps(&maps)
    //ham.populate_static_maps(&maps)
    //ham.debug_maps(&maps)
    //defer ham.destroy_all_maps(&maps) // Ensures cleanup at program exit

    //Delete this line once map maker is created
	ham.MAP_SIZE = "LARGE"

	ham.map_size()
	ham.generate_images()
	height_maps := ham.load_images()
	defer ham.delete_images()

	// Initialize camera
    camera := rl.Camera2D{
        offset =   rl.Vector2{0.0,0.0},
        target =   rl.Vector2{0.0, 0.0},
        rotation = 0.0,
        zoom =     1.0,            
    }

    // Open window
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Kingdom")
	rl.SetTargetFPS(60)

	// Generate Tiles and World Map
	world: ham.World_Map
	ham.init_tile_map(&world.tile_map)
	defer ham.destroy_tile_map(&world.tile_map)
    tile_textures := ham.load_tile_textures()
    ham.populate_tile_map(&world, tile_textures)

    rl.SetExitKey(.KEY_NULL)


	ham.toggle_tile_rendering(&world)

	for !rl.WindowShouldClose()
	{

		rl.BeginDrawing()
		rl.BeginMode2D(camera)
		//handle_camera_input(&camera)

		rl.ClearBackground({100, 100, 100, 255})

		// Render tiles
        ham.render_tile_map(&world)

		rl.EndMode3D()
		rl.EndDrawing()
	}
	
	fmt.println(GLOBAL_SEED)
	rl.CloseWindow()
	rl.EndMode3D()
}


// Generates Seeds For Each Game
seed_generation :: proc()
{	
	data: i32 = 0
	data = rand.int31_max(100000) //
	
	GLOBAL_SEED = data
	rl.SetRandomSeed(u32(GLOBAL_SEED))
}


/*Kingdom_Names :: struct
{
	front_id: IdManager,
	back_id: IdManager,
}



kingdom_generation :: proc(i32)
{
	Kingdom_Names :=
	{
		front_id = rand.int31_max(len()
	}

	Kingdom := 
	{
		name = Kingdom_Names
		{

		},
	} 
}

handle_camera_input :: proc(camera: ^rl.Camera3D)
{
	if rl.IsKeyDown(.W) {

            rl.CameraMoveForward(camera,camera_speed,true)
        }
        if rl.IsKeyDown(.S) {
            rl.CameraMoveForward(camera,(camera_speed-(camera_speed*2)),true)
        }
        if rl.IsKeyDown(.A) {
            rl.CameraMoveRight(camera,(camera_speed-(camera_speed*2)),camera_speed)
        }
        if rl.IsKeyDown(.D) {
            rl.CameraMoveRight(camera,camera_speed,camera_speed)
        }

        if rl.IsKeyPressed(.Q) {
            rotation_angle -= rotation_step
        }
        if rl.IsKeyPressed(.E) {
            rotation_angle += rotation_step
        }

        // Apply rotation
        rad: f64 = rl.DEG2RAD * rotation_angle
        radius: f64 = 10.0
        camera.position.x = camera.target.x + f32(radius * math.cos_f64(rad))
        camera.position.z = camera.target.z + f32(radius * math.sin_f64(rad))

        // Mouse-based movement when the cursor reaches screen edges
        mouse_x := rl.GetMouseX()
        mouse_y := rl.GetMouseY()
        screen_width := rl.GetScreenWidth()
        screen_height := rl.GetScreenHeight()

        if mouse_x < screen_margin {
            camera.position.x -= mouse_edge_scroll_speed
            camera.target.x -= mouse_edge_scroll_speed
        }
        if mouse_x > screen_width - screen_margin {
            camera.position.x += mouse_edge_scroll_speed
            camera.target.x += mouse_edge_scroll_speed
        }
        if mouse_y < screen_margin {
            camera.position.z -= mouse_edge_scroll_speed
            camera.target.z -= mouse_edge_scroll_speed
        }
        if mouse_y > screen_height - screen_margin {
            camera.position.z += mouse_edge_scroll_speed
            camera.target.z += mouse_edge_scroll_speed
        }
}

kingdom_count: [dynamic]int



*/