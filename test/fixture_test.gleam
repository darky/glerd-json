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

pub type TestRecords {
  TestTuple2(str_or_int: #(String, Int))
  TestTuple3(str_or_int: #(String, Int, String))
  TestTuple4(str_or_int: #(String, Int, String, Int))
  TestTuple5(str_or_int: #(String, Int, String, Int, String))
  TestTuple6(str_or_int: #(String, Int, String, Int, String, Int))
  TestDict(dict: Dict(String, Int))
  TestResult(result_field: Result(Int, String))
  TestRecord(nested: NestedRecord)
}
