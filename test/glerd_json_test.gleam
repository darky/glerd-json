import gleeunit
import glerd/types
import glerd_json

pub fn main() {
  gleeunit.main()
}

pub fn generate_test() {
  glerd_json.generate("test", [
    #("TestString", "fixture_test", [#("name", types.IsString)]),
    #("TestInt", "fixture_test", [#("age", types.IsInt)]),
    #("TestFloat", "fixture_test", [#("distance", types.IsFloat)]),
    #("TestBool", "fixture_test", [#("is_exists", types.IsBool)]),
    #("TestMultiple", "fixture_test", [
      #("name", types.IsString),
      #("age", types.IsInt),
    ]),
    #("TestList", "fixture_test", [#("names", types.IsList(types.IsString))]),
    #("TestOption", "fixture_test", [#("some_int", types.IsOption(types.IsInt))]),
  ])
}
