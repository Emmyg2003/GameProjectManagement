package handle_maps
import rl "vendor:raylib"
import "core:fmt"
import "core:os"
import "core:mem"







Height_Maps :: struct
{
	map1: rl.Image,
	map2: rl.Image,
	map3: rl.Image,
	temp: rl.Image,
	hydration: rl.Image,
}


load_images :: proc() -> Height_Maps
{
	img1 := rl.LoadImage("height_maps/map1.png")
	img2 := rl.LoadImage("height_maps/map2.png")
	img3 := rl.LoadImage("height_maps/map3.png")
	img_temp := rl.LoadImage("height_maps/temp.png")
	img_hydration := rl.LoadImage("height_maps/hydration.png")

	return Height_Maps {
        map1 = img1,
        map2 = img2,
        map3 = img3,
        temp = img_temp,
        hydration = img_hydration,
    }
}

//Create Image Files
generate_images :: proc()
{
	map1gen := rl.GenImagePerlinNoise(MAP_WIDTH,MAP_HEIGHT,0,0,10.0)
		rl.ExportImage(map1gen,"height_maps/map1.png")
	map2gen := rl.GenImagePerlinNoise(MAP_WIDTH,MAP_HEIGHT,0,0,10.0)
		rl.ExportImage(map2gen,"height_maps/map2.png")
	map3gen := rl.GenImagePerlinNoise(MAP_WIDTH,MAP_HEIGHT,0,0,10.0)
		rl.ExportImage(map3gen,"height_maps/map3.png")
	tempgen := rl.GenImageGradientLinear(MAP_WIDTH,(MAP_HEIGHT / 2),0,rl.BLACK,rl.WHITE)
		rl.ExportImage(tempgen,"height_maps/temp.png")
	hydrationgen := rl.GenImagePerlinNoise(MAP_WIDTH,MAP_HEIGHT,0,0,10.0)
		rl.ExportImage(hydrationgen,"height_maps/hydration.png")
}

//Deletes Image Files
delete_images :: proc() {
    files := []string{
        "height_maps/map1.png",
        "height_maps/map2.png",
        "height_maps/map3.png",
        "height_maps/temp.png",
        "height_maps/hydration.png",
    }

    for file in files {
        err := os.remove(file)
        if err != os.ERROR_NONE {
            fmt.println("Failed to delete:", file, "Error:", err)
        } else {
            fmt.println("Deleted:", file)
        }
    }
}

/*merge_height_maps :: proc(h: ^Height_Maps) -> []f32
{
	height_map := make([]f32, MAP_WIDTH * MAP_HEIGHT)
	
	for i := 0; i < int(MAP_WIDTH) * int(MAP_HEIGHT); i += 1 {
        height_map[i] = (h.map1[i] + h.map2[i] * 0.5 + h.map3[i] * 0.25)  // Weighted sum
        height_map[i] *= 2.0  // Increase height variation
    }
    return height_map
}

generate_terrain_mesh :: proc(height_map: []f32, MAP_WIDTH: int, MAP_HEIGHT: int) -> rl.Mesh {
    mesh := rl.Mesh{}
    
    num_vertices := int(MAP_WIDTH) * int(MAP_HEIGHT)
    num_triangles := (int(MAP_WIDTH) - 1) * (int(MAP_HEIGHT) - 1) * 2
    
    mesh.vertexCount = num_vertices
    mesh.triangleCount = num_triangles

    // Allocate vertex buffers
    mesh.vertices = mem.alloc([num_vertices * 3]f32)
    mesh.texcoords = mem.alloc([num_vertices * 2]f32)
    mesh.normals = mem.alloc([num_vertices * 3]f32)
    mesh.indices = mem.alloc([num_triangles * 3]u16)

    for y := 0; y < MAP_HEIGHT; y += 1 {
        for x := 0; x < MAP_WIDTH; x += 1 {
            index := y * MAP_WIDTH + x
            height_value := height_map[index]

            // Assign vertex positions
            mesh.vertices[index * 3 + 0] = f32(x)  // X
            mesh.vertices[index * 3 + 1] = height_value  // Y (MAP_HEIGHT)
            mesh.vertices[index * 3 + 2] = f32(y)  // Z
            
            // Assign texture coordinates
            mesh.texcoords[index * 2 + 0] = f32(x) / f32(MAP_WIDTH)
            mesh.texcoords[index * 2 + 1] = f32(y) / f32(MAP_HEIGHT)

            // Assign default normals (will be auto-generated later)
            mesh.normals[index * 3 + 0] = 0
            mesh.normals[index * 3 + 1] = 1
            mesh.normals[index * 3 + 2] = 0
        }
    }

    // Generate indices for triangles
    idx := 0
    for y := 0; y < MAP_HEIGHT - 1; y += 1 {
        for x := 0; x < MAP_WIDTH - 1; x += 1 {
            i0 := y * MAP_WIDTH + x
            i1 := y * MAP_WIDTH + (x + 1)
            i2 := (y + 1) * MAP_WIDTH + x
            i3 := (y + 1) * MAP_WIDTH + (x + 1)

            mesh.indices[idx + 0] = u16(i0)
            mesh.indices[idx + 1] = u16(i2)
            mesh.indices[idx + 2] = u16(i1)

            mesh.indices[idx + 3] = u16(i1)
            mesh.indices[idx + 4] = u16(i2)
            mesh.indices[idx + 5] = u16(i3)

            idx += 6
        }
    }

    rl.UploadMesh(&mesh, true)
    return mesh
}*/

render_terrain :: proc(model: rl.Model, texture: rl.Texture2D) {
    rl.DrawModel(model, rl.Vector3{0, 0, 0}, 1.0, rl.WHITE)
}

