#[derive(NativeClass)]
#[inherit(Node)]
pub struct HelloWorld;

fn init(handle: InitHandle) {
    handle.add_class::<HelloWorld>();
}

impl HelloWorld {
    fn new(_owner: &Node) -> Self {
        HelloWorld
    }
}

#[methods]
impl HelloWorld {}
