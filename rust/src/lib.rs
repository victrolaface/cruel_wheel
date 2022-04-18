use gdnative::prelude::*;

// the HelloWorld "class"
#[derive(NativeClass)]
#[inherit(Node)]
pub struct HelloWorld;

// register Godot classes
fn init(handle: InitHandle){
    // register hello world type
    handle.add_class::<HelloWorld>();
}

impl HelloWorld {
    // constructor of class
    fn new(_owner: &Node) -> Self {
        HelloWorld
    }
}

#[methods]
impl HelloWorld {}
// entry point of dyn lib
godot_init!(init);