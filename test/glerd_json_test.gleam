import fixture_test
import gleam/dict
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import glerd/types
import glerd_json
import glerd_json_gen

const str_json = "{\"name\":\"test\"}"

const int_json = "{\"age\":123}"

const float_json = "{\"distance\":1.1}"

const bool_json = "{\"is_exists\":true}"

const multiple_fields_json = "{\"name\":\"test\",\"age\":123}"

const list_json = "{\"names\":[\"test1\",\"test2\"]}"

const option_json = "{\"some_int\":123}"

const option_none_json = "{\"some_int\":null}"

const tup2_json = "{\"str_or_int\":[\"test\",123]}"

const tup3_json = "{\"str_or_int\":[\"test\",123,\"test2\"]}"

const tup4_json = "{\"str_or_int\":[\"test\",123,\"test2\",456]}"

const tup5_json = "{\"str_or_int\":[\"test\",123,\"test2\",456,\"test3\"]}"

const tup6_json = "{\"str_or_int\":[\"test\",123,\"test2\",456,\"test3\",789]}"

const nested_json = "{\"nested\":{\"name\":\"test\"}}"

const dict_json = "{\"dict\":{\"test_field\":123}}"

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
    #("TestTuple2", "fixture_test", [
      #("str_or_int", types.IsTuple2(types.IsString, types.IsInt)),
    ]),
    #("TestTuple3", "fixture_test", [
      #(
        "str_or_int",
        types.IsTuple3(types.IsString, types.IsInt, types.IsString),
      ),
    ]),
    #("TestTuple4", "fixture_test", [
      #(
        "str_or_int",
        types.IsTuple4(types.IsString, types.IsInt, types.IsString, types.IsInt),
      ),
    ]),
    #("TestTuple5", "fixture_test", [
      #(
        "str_or_int",
        types.IsTuple5(
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
          types.IsString,
        ),
      ),
    ]),
    #("TestTuple6", "fixture_test", [
      #(
        "str_or_int",
        types.IsTuple6(
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
        ),
      ),
    ]),
    #("TestRecord", "fixture_test", [
      #("nested", types.IsRecord("NestedRecord")),
    ]),
    #("NestedRecord", "fixture_test", [#("name", types.IsString)]),
    #("TestDict", "fixture_test", [
      #("dict", types.IsDict(types.IsString, types.IsInt)),
    ]),
  ])
}

pub fn encode_string_test() {
  fixture_test.TestString("test")
  |> glerd_json_gen.test_string_json_encode
  |> should.equal(str_json)
}

pub fn decode_string_test() {
  str_json
  |> glerd_json_gen.test_string_json_decode
  |> should.equal(Ok(fixture_test.TestString("test")))
}

pub fn encode_int_test() {
  fixture_test.TestInt(123)
  |> glerd_json_gen.test_int_json_encode
  |> should.equal(int_json)
}

pub fn decode_int_test() {
  int_json
  |> glerd_json_gen.test_int_json_decode
  |> should.equal(Ok(fixture_test.TestInt(123)))
}

pub fn encode_float_test() {
  fixture_test.TestFloat(1.1)
  |> glerd_json_gen.test_float_json_encode
  |> should.equal(float_json)
}

pub fn decode_float_test() {
  float_json
  |> glerd_json_gen.test_float_json_decode
  |> should.equal(Ok(fixture_test.TestFloat(1.1)))
}

pub fn encode_bool_test() {
  fixture_test.TestBool(True)
  |> glerd_json_gen.test_bool_json_encode
  |> should.equal(bool_json)
}

pub fn decode_bool_test() {
  bool_json
  |> glerd_json_gen.test_bool_json_decode
  |> should.equal(Ok(fixture_test.TestBool(True)))
}

pub fn encode_multiple_fields_test() {
  fixture_test.TestMultiple("test", 123)
  |> glerd_json_gen.test_multiple_json_encode
  |> should.equal(multiple_fields_json)
}

pub fn decode_multiple_fields_test() {
  multiple_fields_json
  |> glerd_json_gen.test_multiple_json_decode
  |> should.equal(Ok(fixture_test.TestMultiple("test", 123)))
}

pub fn encode_list_test() {
  fixture_test.TestList(["test1", "test2"])
  |> glerd_json_gen.test_list_json_encode
  |> should.equal(list_json)
}

pub fn decode_list_test() {
  list_json
  |> glerd_json_gen.test_list_json_decode
  |> should.equal(Ok(fixture_test.TestList(["test1", "test2"])))
}

pub fn encode_option_test() {
  fixture_test.TestOption(Some(123))
  |> glerd_json_gen.test_option_json_encode
  |> should.equal(option_json)
}

pub fn decode_option_test() {
  option_json
  |> glerd_json_gen.test_option_json_decode
  |> should.equal(Ok(fixture_test.TestOption(Some(123))))
}

pub fn encode_option_none_test() {
  fixture_test.TestOption(None)
  |> glerd_json_gen.test_option_json_encode
  |> should.equal(option_none_json)
}

pub fn decode_option_none_test() {
  option_none_json
  |> glerd_json_gen.test_option_json_decode
  |> should.equal(Ok(fixture_test.TestOption(None)))
}

pub fn encode_tuple2_test() {
  fixture_test.TestTuple2(#("test", 123))
  |> glerd_json_gen.test_tuple2_json_encode
  |> should.equal(tup2_json)
}

pub fn decode_tuple2_test() {
  tup2_json
  |> glerd_json_gen.test_tuple2_json_decode
  |> should.equal(Ok(fixture_test.TestTuple2(#("test", 123))))
}

pub fn encode_tuple3_test() {
  fixture_test.TestTuple3(#("test", 123, "test2"))
  |> glerd_json_gen.test_tuple3_json_encode
  |> should.equal(tup3_json)
}

pub fn decode_tuple3_test() {
  tup3_json
  |> glerd_json_gen.test_tuple3_json_decode
  |> should.equal(Ok(fixture_test.TestTuple3(#("test", 123, "test2"))))
}

pub fn encode_tuple4_test() {
  fixture_test.TestTuple4(#("test", 123, "test2", 456))
  |> glerd_json_gen.test_tuple4_json_encode
  |> should.equal(tup4_json)
}

pub fn decode_tuple4_test() {
  tup4_json
  |> glerd_json_gen.test_tuple4_json_decode
  |> should.equal(Ok(fixture_test.TestTuple4(#("test", 123, "test2", 456))))
}

pub fn encode_tuple5_test() {
  fixture_test.TestTuple5(#("test", 123, "test2", 456, "test3"))
  |> glerd_json_gen.test_tuple5_json_encode
  |> should.equal(tup5_json)
}

pub fn decode_tuple5_test() {
  tup5_json
  |> glerd_json_gen.test_tuple5_json_decode
  |> should.equal(
    Ok(fixture_test.TestTuple5(#("test", 123, "test2", 456, "test3"))),
  )
}

pub fn encode_tuple6_test() {
  fixture_test.TestTuple6(#("test", 123, "test2", 456, "test3", 789))
  |> glerd_json_gen.test_tuple6_json_encode
  |> should.equal(tup6_json)
}

pub fn decode_tuple6_test() {
  tup6_json
  |> glerd_json_gen.test_tuple6_json_decode
  |> should.equal(
    Ok(fixture_test.TestTuple6(#("test", 123, "test2", 456, "test3", 789))),
  )
}

pub fn encode_nested_test() {
  fixture_test.TestRecord(fixture_test.NestedRecord("test"))
  |> glerd_json_gen.test_record_json_encode
  |> should.equal(nested_json)
}

pub fn decode_nested_test() {
  nested_json
  |> glerd_json_gen.test_record_json_decode
  |> should.equal(
    Ok(fixture_test.TestRecord(fixture_test.NestedRecord("test"))),
  )
}

pub fn encode_dict_test() {
  fixture_test.TestDict(dict.from_list([#("test_field", 123)]))
  |> glerd_json_gen.test_dict_json_encode
  |> should.equal(dict_json)
}

pub fn decode_dict_test() {
  dict_json
  |> glerd_json_gen.test_dict_json_decode
  |> should.equal(
    Ok(fixture_test.TestDict(dict.from_list([#("test_field", 123)]))),
  )
}
