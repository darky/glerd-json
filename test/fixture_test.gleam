import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type NestedRecord {
  NestedRecord(name: String)
}

pub type TestString {
  TestString(name: String)
}

pub type TestInt {
  TestInt(age: Int)
}

pub type TestFloat {
  TestFloat(distance: Float)
}

pub type TestBool {
  TestBool(is_exists: Bool)
}

pub type TestMultiple {
  TestMultiple(name: String, age: Int)
}

pub type TestList {
  TestList(names: List(String))
}

pub type TestOption {
  TestOption(some_int: Option(Int))
}

pub type TestTuple2 {
  TestTuple2(str_or_int: #(String, Int))
}

pub type TestTuple3 {
  TestTuple3(str_or_int: #(String, Int, String))
}

pub type TestTuple4 {
  TestTuple4(str_or_int: #(String, Int, String, Int))
}

pub type TestTuple5 {
  TestTuple5(str_or_int: #(String, Int, String, Int, String))
}

pub type TestTuple6 {
  TestTuple6(str_or_int: #(String, Int, String, Int, String, Int))
}

pub type TestRecord {
  TestRecord(nested: NestedRecord)
}

pub type TestDict {
  TestDict(dict: Dict(String, Int))
}
