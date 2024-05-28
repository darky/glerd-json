import gleeunit
import glerd/types
import glerd_json

pub fn main() {
  gleeunit.main()
}

pub fn generate_test() {
  glerd_json.generate("test", [#("TestString", [#("name", types.IsString)])])
}
