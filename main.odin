package main

import "core:fmt"
import "core:path/filepath"
import "core:os"

jwalk :: proc(directory: string,file_list: ^[dynamic]string){

    f, err := os.open(directory)
    defer os.close(f)

    if err != os.ERROR_NONE {
        fmt.eprintln("Could not open directory for reading", err)
        os.exit(1)
    }

    fls: []os.File_Info
    defer os.file_info_slice_delete(fls)

    fls, err = os.read_dir(f, -1)
    if err != os.ERROR_NONE {
        fmt.eprintfln("Could not read the directory: %s", err, directory)
        os.exit(2)
    }
    
    for fi in fls{

        _, name := filepath.split(fi.fullpath)

        if fi.is_dir {
            fmt.printfln("%v (directory)", name)
            jwalk(fi.fullpath, file_list)
        }
        else {
            //add to list
            fmt.printfln("%v (file)", name)
            new_file: string = fi.fullpath
            append(file_list, new_file)
        }

    }

}

main :: proc (){

    top_dir : string = "/home/jatkinson/Downloads"
    fmt.println("Howdy!")

    file_list := make([dynamic] string, 0, 0)
    defer delete(file_list)


    // test walking a folder without walk library
    jwalk(top_dir, &file_list)
    
    fmt.println("Done walking the directory")
    for file in file_list{
        fmt.printfln("%v", file)
    }
    unordered_remove(&file_list, 0)


}