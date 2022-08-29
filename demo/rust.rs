//! Doc comment

use std::fmt::Debug;

const SOMETHING: u32 = 0x00010000;

pub enum OneOf<T1, T2> {
    This(T1),
    That(T2),
}

struct SomeStruct {
    thing1: u32,
    thing2: &str
}

impl SomeStruct {

}

impl From<&str> for SomeStruct {
    fn from(n: &str) -> Self {
        todo!()
    }
}

const SOME_CONST: u32 = 123456;

/*! Inner block doc */
/** Outer block doc */

fn main() {
    let mut foo: u16 = 990;
    let bar = "Some string"::to_string();

    println!("Hello, jello! {foo}");

    if c == 1 {
        if x == true {
            return;
        }
    }

    process::exit(0);
}
