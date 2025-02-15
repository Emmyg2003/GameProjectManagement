package handle_maps

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"
import "core:encoding/json"
import "core:os"

main :: proc()
{
    maps: Static_Maps
    init_static_maps(&maps)
    unmarshal_static_maps(&maps)
    debug_static_maps(&maps)
}

technology :: struct
{
    name: string,
    id: int,
    description: string,
    relation: string,
    form: string,
    discipline: string,
}

Name :: struct
{
    name: string,
    id: int,
}

kingdom_name_form :: struct
{
    nameForm: string,
    id: int,
}

Static_Maps :: struct
{
    civil_technologies: Handle_Map(technology),
    military_technologies: Handle_Map(technology),
    culture_technologies: Handle_Map(technology),
    magic_forms: Handle_Map()
}

init_static_maps :: proc(maps: ^Static_Maps, allocator := context.allocator)
{
    init(&maps.civil_technologies,allocator)
    init(&maps.military_technologies,allocator)
    init(&maps.culture_technology,allocator)
    init(&maps.magic_technology,allocator)
    init(&maps.magic_forms,allocator)
    init(&maps.magic_disciplines,allocator)
    init(&maps.kingdom_names,allocator)
    init(&maps.kingdom_name_forms,allocator)
    init(&maps.name_lists,allocator)
    init(&maps.economic_system,allocator)
    init(&maps.political_system,allocator)
}

destroy_static_maps :: proc(maps: ^Static_Maps)
{
    destroy(&maps.civil_technologies)
    destroy(&maps.military_technologies)
    destroy(&maps.culture_technology)
    destroy(&maps.magic_technology)
    destroy(&maps.magic_forms)
    destroy(&maps.magic_disciplines)
    destroy(&maps.kingdom_names)
    destroy(&maps.kingdom_name_forms)
    destroy(&maps.name_lists)
    destroy(&maps.economic_system)
    destroy(&maps.political_system)
}

unmarshal_static_maps :: proc(m: ^Static_Maps)
{
    data, ok := os.read_entire_file_from_filename("id_lists/static_maps.json")
    if !ok {
        fmt.eprintln("Failed to load static maps")
        return
    }
    defer delete(data)
    temp_data: struct {
        civil_technologies: []technology,
        military_technologies: []technology,
    }
    unmarshal_err := json.unmarshal(data, &temp_data)
    if unmarshal_err != nil
    {
        fmt.eprintln("Failed to unmarshal static maps")
        return
    }

    for tech in temp_data.civil_technologies {
        _ = insert(&m.civil_technologies, tech)
    }
    for tech in temp_data.military_technologies {
        _ = insert (&m.military_technologies, tech)
    }

    
}

debug_static_maps :: proc(maps: ^Static_Maps){
            // Retrieve and print inserted technology IDs
    fmt.println("Civil Technologies:")
    for handle, i in maps.civil_technologies.handles {
        value, exists := get(&maps.civil_technologies, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }

    fmt.println("Military Technologies:")
    for handle, i in maps.military_technologies.handles {
        value, exists := get(&maps.military_technologies, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }
/*
    fmt.println("Cultural Technologies:")
    for handle, i in maps.culture_technology.handles {
        value, exists := get(&maps.culture_technology, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }

    fmt.println("Magic Technologies:")
    for handle, i in maps.magic_technology.handles {
        value, exists := get(&maps.magic_technology, handle)
        form_name: string
        discipline_name: string
        for form_handle in maps.magic_forms.handles
        {
            form_value, exists := get(&maps.magic_forms, handle)
            if value.form == form_value.id && exists
            {
                form_name = form_value.name
            }
            else
            {
                return
            }
        }
        for discipline_handle in maps.magic_disciplines.handles
        {
            discipline_value, exists := get(&maps.magic_disciplines, handle)
            if value.discipline == discipline_value.id && exists
            {
                discipline_name = discipline_value.name
            }
            else
            {
                return
            }
        }

        if exists{
            fmt.println(i, " - ", value.name, "ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", " - ", value.relation, " | ", "Form - ", form_name, " | ", "Discipline - ", discipline_name)
        }
        else{
            fmt.println("Empty")
        }
    }
    fmt.println("Kingdom Names:")
    for handle, i in maps.kingdom_names.handles {
        value, exists := get(&maps.kingdom_names, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")")
        }
        else{
            fmt.println("Empty")
        }
    }
    fmt.println("Kingdom Name Forms:")
    for handle, i in maps.kingdom_name_forms.handles {
        value, exists := get(&maps.kingdom_name_forms, handle)
        if exists {
            random_kingdom_name := pick_random_kingdom_name(maps)
            formatted_name := fmt.tprintf(value.name_form, random_kingdom_name)
            fmt.println(i, " - ", formatted_name, " (ID: ", value.id, ")")
        }
        else{
            fmt.println("Empty")
        }
    }*/
}
/*
main :: proc()
{
    stat_maps: All_Static_Maps
    dyn_maps: All_Dynamic_Maps
    init_all_static_maps(&stat_maps)
    init_all_dynamic_maps(&dyn_maps)
    generate_kingdoms(&dyn_maps,&stat_maps)

    fmt.println("Kingdom Data: ")
    for handle, i in dyn_maps.kingdom_data.handles {
        value, exists := get(&dyn_maps.kingdom_data, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Economic System", " - ", value.economic_system, " | ", "Political System", value.political_system)
        }
        else{
            fmt.println("Empty")
        }
    }
}



kingdom_data :: struct
{
    name: string,
    id: int,

    civil_technologies: [dynamic]int,
    military_technologies: [dynamic]int,
    cultural_technologies: [dynamic]int,
    magic_discipline_access: [dynamic]int,

    tiles: [dynamic]rl.Vector2,
    entities: [dynamic]int,

    wealth: i128,
    total_available_biomass: i64,
    total_stored_biomass: i64,

    economic_system: string,
    political_system: string,

    political_corruption: f16,
    unrest: f16,

    aggression: f16,
    emotional_hardiness: f16,
}

starting_kingdom_number: int

generate_kingdoms :: proc(maps: ^All_Dynamic_Maps, stat_maps: ^All_Static_Maps)
{
    if MAP_SIZE == "LARGE"
    {
        starting_kingdom_number = 6
        for starting_kingdom_number > 0
        {
            _ = insert(&maps.kingdom_data ,kingdom_data{})
            starting_kingdom_number = starting_kingdom_number - 1
        }
        for handle, i in maps.kingdom_data.handles
        {
            _ = insert(&maps.kingdom_data, kingdom_data{
                name = pick_random_kingdom_name(stat_maps),
                id = 100 + i,

                economic_system = pick_economic_system(stat_maps),
                political_system = pick_political_system(stat_maps),
            })
        }
    }

}
id: int

pick_economic_system :: proc(maps: ^All_Static_Maps) -> string
{
    names := make([dynamic]string)
    for handle in maps.economic_system.handles{
        value, exists := get(&maps.economic_system, handle)
        append(&names,value.name)
    }
    name = rand.choice(names[:])
    return name
}

pick_political_system :: proc(maps: ^All_Static_Maps) -> string
{
    names := make([dynamic]string)
    for handle in maps.political_system.handles{
        value, exists := get(&maps.political_system, handle)
        append(&names,value.name)
    }
    name = rand.choice(names[:])
    return name
}

populate_dynamic_maps :: proc(maps: ^All_Dynamic_Maps, stat_maps: ^All_Static_Maps)
{
    //Populate Kingdoms
    //if MAP_SIZE = "LARGE" && is_generating_world

}

All_Dynamic_Maps :: struct {
    kingdom_data: Handle_Map(kingdom_data),
}

init_all_dynamic_maps :: proc(maps: ^All_Dynamic_Maps,allocator := context.allocator)
{
    init(&maps.kingdom_data)
}

destroy_all_dynamic_maps :: proc(maps: ^All_Dynamic_Maps)
{
    destroy(&maps.kingdom_data)
}

/* This details the initialization, population, and destruction of static handle maps. */

civil_technology :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int
}

mil_technology :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int
}

culture_technology :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int
}

magic_forms :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int
}

magic_disciplines :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int,
}

magic_technology :: struct
{
    name: string,
    id: int,
    description: string,
    relation: int,
    form: int,
    discipline: int,
}

/*Details used to construct randomly generated kingdoms*/

kingdom_names :: struct
{
    name: string,
    id: int,
}

kingdom_name_forms :: struct
{
    name_form: string,
    id: int,
}

name_lists :: struct
{
    name: string,
    id: int,
}

economic_system :: struct
{
    name: string,
    id: int,
}

political_system :: struct
{
    name: string,
    id: int,
}

All_Static_Maps :: struct {
    civil_technology: Handle_Map(civil_technology),
    mil_technology: Handle_Map(mil_technology),
    culture_technology: Handle_Map(culture_technology),
    magic_technology: Handle_Map(magic_technology),

    magic_forms: Handle_Map(magic_forms),
    magic_disciplines: Handle_Map(magic_disciplines),

    kingdom_names: Handle_Map(kingdom_names),
    kingdom_name_forms: Handle_Map(kingdom_name_forms),

    name_lists: Handle_Map(name_lists),

    economic_system: Handle_Map(economic_system),
    political_system: Handle_Map(political_system),
}

get_handles :: proc(maps: ^All_Static_Maps)
{
    for
}
marshal_static_maps :: proc(maps: ^All_Static_Maps)
{
    fmt.println("Some of Odin's builtin constants")
    path := len(os.args) > 1 ? os.args[1] : "static_maps.json"

    // This uses an "anonymous struct type". You could equally well do
    //
    //     info := Odin_Info { ODIN_OS, ODIN_ARCH, ... }
    //
    // where you make a struct type `Odin_Info` that contains the same fields.
    data := struct {
        civil_technology: []civil_technology,
        mil_technology: []mil_technology,
        culture_technology: []culture_technology,
        magic_disciplines: []magic_disciplines,
        magic_forms: []magic_forms,
        magic_technology: []magic_technology,
        kingdom_names: []kingdom_names,
        kingdom_name_forms: []kingdom_name_forms,
        economic_system: []economic_system,
        political_system: []political_system,
    }{
        civil_technology = get(&maps.civil_technology),
        mil_technology = get(&maps.mil_technology),
        culture_technology = get(&maps.culture_technology),
        magic_disciplines = get(&maps.magic_disciplines),
        magic_forms = get(&maps.magic_forms),
        magic_technology = get(&maps.magic_technology),
        kingdom_names = get_all_entries(&maps.kingdom_names),
        kingdom_name_forms = get_all_entries(&maps.kingdom_name_forms),
        economic_system = get_all_entries(&maps.economic_system),
        political_system = get_all_entries(&maps.political_system),
    }

    fmt.println("Static_Maps:")
    fmt.printfln("%#v", data)

    json_data, err := json.marshal(data, {
        // Adds indentation etc
        pretty         = true,

        // Output enum member names instead of numeric value.
        use_enum_names = true,
    })

    if err != nil {
        fmt.eprintfln("Unable to marshal JSON: %v", err)
        os.exit(1)
    }

    fmt.println("JSON:")
    fmt.printfln("%s", json_data)
    fmt.printfln("Writing: %s", path)
    werr := os.write_entire_file_or_err(path, json_data)

    if werr != nil {
        fmt.eprintfln("Unable to write file: %v", werr)
        os.exit(1)
    }

    fmt.println("Done")
}

unmarshal_static_maps :: proc(maps: ^All_Static_Maps)
{
    data, ok := os.read_entire_file_from_filename("static_maps.json")
    if !ok {
        fmt.eprintln("Failed to load static maps")
        return
    }
    defer delete(data)

    unmarshal_err := json.unmarshal(data,maps)
    if unmarshal_err != nil
    {
        fmt.eprintln("Failed to unmarshal static maps")
        return
    }
    fmt.eprintf("Result %v/n",maps)
}

// Procedure to populate the handle maps with some technology IDs
populate_static_maps :: proc(maps: ^All_Static_Maps) {

    // Civil Technologies
    _ = insert(&maps.civil_technology, civil_technology{name="Agriculture", id=101, description="a"})
    _ = insert(&maps.civil_technology, civil_technology{name="Construction", id=102, description="a"})
    _ = insert(&maps.civil_technology, civil_technology{name="Medicine", id=103, description="a"})

    // Military Technologies
    _ = insert(&maps.mil_technology, mil_technology{name="Archery", id=201, description="a"})
    _ = insert(&maps.mil_technology, mil_technology{name="Gunpowder", id=202, description="a"})
    _ = insert(&maps.mil_technology, mil_technology{name="Naval Warfare", id=203, description="a"})

    // Cultural Technologies
    _ = insert(&maps.culture_technology, culture_technology{name="Philosophy", id=301, description="a"})
    _ = insert(&maps.culture_technology, culture_technology{name="Music", id=302, description="a"})
    _ = insert(&maps.culture_technology, culture_technology{name="Painting", id=303, description="a"})


    // Magic Forms
    _ = insert(&maps.magic_forms, magic_forms{name="Animus",id=101,description="a",relation=0})
    _ = insert(&maps.magic_forms, magic_forms{name="Essentia",id=102,description="a",relation=0})
    _ = insert(&maps.magic_forms, magic_forms{name="Elementum",id=103,description="a",relation=0})
    _ = insert(&maps.magic_forms, magic_forms{name="Solum",id=104,description="a",relation=0})

    // Magic Discipline
    _ = insert(&maps.magic_disciplines, magic_disciplines{name="Shamanism",id=101,description="a",relation=0})
    _ = insert(&maps.magic_disciplines, magic_disciplines{name="Animism",id=102,description="a",relation=0})
    _ = insert(&maps.magic_disciplines, magic_disciplines{name="Totemism",id=101,description="a",relation=0})
    _ = insert(&maps.magic_disciplines, magic_disciplines{name="Occultism",id=101,description="a",relation=0})


    // Magic Technologies
    _ = insert(&maps.magic_technology, magic_technology{name="Fire Starting",id=101,description="a", relation=0,form=101,discipline=101})


    // Kingdom Names
    _ = insert(&maps.kingdom_names, kingdom_names{name="Elsava", id=101})

    // Kingdom Name Forms
    _ = insert(&maps.kingdom_name_forms, kingdom_name_forms{name_form="Republic of %s",id=101})
    _ = insert(&maps.kingdom_name_forms, kingdom_name_forms{name_form="Kingdom of %s",id=102})
    _ = insert(&maps.kingdom_name_forms, kingdom_name_forms{name_form="%s",id=103})

    // Name lists
    _ = insert(&maps.name_lists, name_lists{name="",id=101})

    // Economic System
    _ = insert(&maps.economic_system, economic_system{name="Hunter-Gatherer",id=101})
    _ = insert(&maps.economic_system, economic_system{name="Traditional Agrarian",id=102})
    _ = insert(&maps.economic_system, economic_system{name="Feudal",id=103})
    _ = insert(&maps.economic_system, economic_system{name="Mercantilist",id=104})
    _ = insert(&maps.economic_system, economic_system{name="Laissez-Faire",id=105})
    _ = insert(&maps.economic_system, economic_system{name="Mixed",id=106})
    _ = insert(&maps.economic_system, economic_system{name="Command",id=107})
    _ = insert(&maps.economic_system, economic_system{name="Market Socialism",id=108})
    _ = insert(&maps.economic_system, economic_system{name="Communism",id=109})
    _ = insert(&maps.economic_system, economic_system{name="State Capitalism",id=110})

    // Political System
    _ = insert(&maps.political_system, political_system{name="Tribal Chiefdoms",id=101})
    _ = insert(&maps.political_system, political_system{name="Direct Democracy",id=102})
    _ = insert(&maps.political_system, political_system{name="Oligarchy",id=103})
    _ = insert(&maps.political_system, political_system{name="Republic",id=104})
    _ = insert(&maps.political_system, political_system{name="Monarchy",id=105})
    _ = insert(&maps.political_system, political_system{name="Feudal",id=106})
    _ = insert(&maps.political_system, political_system{name="Theocracy",id=107})
    _ = insert(&maps.political_system, political_system{name="Communist State",id=108})
    _ = insert(&maps.political_system, political_system{name="Fascist",id=109})
    _ = insert(&maps.political_system, political_system{name="Magocracy",id=110})
    _ = insert(&maps.political_system, political_system{name="Dictatorship",id=111})


    fmt.println("Technology maps populated successfully!")
}




init_all_static_maps :: proc(maps: ^All_Static_Maps, allocator := context.allocator){
    init(&maps.civil_technology,allocator)
    init(&maps.mil_technology,allocator)
    init(&maps.culture_technology,allocator)
    init(&maps.magic_technology,allocator)
    init(&maps.magic_forms,allocator)
    init(&maps.magic_disciplines,allocator)
    init(&maps.kingdom_names,allocator)
    init(&maps.kingdom_name_forms,allocator)
    init(&maps.name_lists,allocator)
    init(&maps.economic_system,allocator)
    init(&maps.political_system,allocator)
}

destroy_all_static_maps :: proc(maps: ^All_Static_Maps){
    destroy(&maps.civil_technology)
    destroy(&maps.mil_technology)
    destroy(&maps.culture_technology)
    destroy(&maps.magic_technology)
    destroy(&maps.magic_forms)
    destroy(&maps.magic_disciplines)
    destroy(&maps.kingdom_names)
    destroy(&maps.kingdom_name_forms)
    destroy(&maps.name_lists)
    destroy(&maps.economic_system)
    destroy(&maps.political_system)
}

debug_static_maps :: proc(maps: ^All_Static_Maps){
            // Retrieve and print inserted technology IDs
    fmt.println("Civil Technologies:")
    for handle, i in maps.civil_technology.handles {
        value, exists := get(&maps.civil_technology, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }

    fmt.println("Military Technologies:")
    for handle, i in maps.mil_technology.handles {
        value, exists := get(&maps.mil_technology, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }

    fmt.println("Cultural Technologies:")
    for handle, i in maps.culture_technology.handles {
        value, exists := get(&maps.culture_technology, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", value.relation)
        }
        else{
            fmt.println("Empty")
        }
    }

    fmt.println("Magic Technologies:")
    for handle, i in maps.magic_technology.handles {
        value, exists := get(&maps.magic_technology, handle)
        form_name: string
        discipline_name: string
        for form_handle in maps.magic_forms.handles
        {
            form_value, exists := get(&maps.magic_forms, handle)
            if value.form == form_value.id && exists
            {
                form_name = form_value.name
            }
            else
            {
                return
            }
        }
        for discipline_handle in maps.magic_disciplines.handles
        {
            discipline_value, exists := get(&maps.magic_disciplines, handle)
            if value.discipline == discipline_value.id && exists
            {
                discipline_name = discipline_value.name
            }
            else
            {
                return
            }
        }

        if exists{
            fmt.println(i, " - ", value.name, "ID: ", value.id, ")", "Description", " - ", value.description, " | ", "Relation", " - ", value.relation, " | ", "Form - ", form_name, " | ", "Discipline - ", discipline_name)
        }
        else{
            fmt.println("Empty")
        }
    }
    fmt.println("Kingdom Names:")
    for handle, i in maps.kingdom_names.handles {
        value, exists := get(&maps.kingdom_names, handle)
        if exists {
            fmt.println(i, " - ", value.name, " (ID: ", value.id, ")")
        }
        else{
            fmt.println("Empty")
        }
    }
    fmt.println("Kingdom Name Forms:")
    for handle, i in maps.kingdom_name_forms.handles {
        value, exists := get(&maps.kingdom_name_forms, handle)
        if exists {
            random_kingdom_name := pick_random_kingdom_name(maps)
            formatted_name := fmt.tprintf(value.name_form, random_kingdom_name)
            fmt.println(i, " - ", formatted_name, " (ID: ", value.id, ")")
        }
        else{
            fmt.println("Empty")
        }
    }
}

name: string

pick_random_kingdom_name :: proc(maps: ^All_Static_Maps) -> string
{
    names := make([dynamic]string)
    for handle in maps.kingdom_names.handles{
        value, exists := get(&maps.kingdom_names, handle)
        append(&names,value.name)
    }
    name = rand.choice(names[:])
    return name
}*/