// this file was generated via glerd_json

import gleam/dict
import gleam/dynamic
import gleam/json
import gleam/list

import fixture_test

pub fn test_string_json_encode(x: fixture_test.TestString) {
  json.object([#("name", json.string(x.name))])
  |> json.to_string
}

pub fn test_string_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestString,
    dynamic.field("name", dynamic.string),
  )
  |> json.decode(s, _)
}

pub fn test_int_json_encode(x: fixture_test.TestInt) {
  json.object([#("age", json.int(x.age))])
  |> json.to_string
}

pub fn test_int_json_decode(s: String) {
  dynamic.decode1(fixture_test.TestInt, dynamic.field("age", dynamic.int))
  |> json.decode(s, _)
}

pub fn test_float_json_encode(x: fixture_test.TestFloat) {
  json.object([#("distance", json.float(x.distance))])
  |> json.to_string
}

pub fn test_float_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestFloat,
    dynamic.field("distance", dynamic.float),
  )
  |> json.decode(s, _)
}

pub fn test_bool_json_encode(x: fixture_test.TestBool) {
  json.object([#("is_exists", json.bool(x.is_exists))])
  |> json.to_string
}

pub fn test_bool_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestBool,
    dynamic.field("is_exists", dynamic.bool),
  )
  |> json.decode(s, _)
}

pub fn test_multiple_json_encode(x: fixture_test.TestMultiple) {
  json.object([#("name", json.string(x.name)), #("age", json.int(x.age))])
  |> json.to_string
}

pub fn test_multiple_json_decode(s: String) {
  dynamic.decode2(
    fixture_test.TestMultiple,
    dynamic.field("name", dynamic.string),
    dynamic.field("age", dynamic.int),
  )
  |> json.decode(s, _)
}

pub fn test_list_json_encode(x: fixture_test.TestList) {
  json.object([#("names", json.array(x.names, json.string))])
  |> json.to_string
}

pub fn test_list_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestList,
    dynamic.field("names", dynamic.list(dynamic.string)),
  )
  |> json.decode(s, _)
}

pub fn test_option_json_encode(x: fixture_test.TestOption) {
  json.object([#("some_int", json.nullable(x.some_int, json.int))])
  |> json.to_string
}

pub fn test_option_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestOption,
    dynamic.field("some_int", dynamic.optional(dynamic.int)),
  )
  |> json.decode(s, _)
}

pub fn test_tuple2_json_encode(x: fixture_test.TestTuple2) {
  json.object([
    #(
      "str_or_int",
      json.preprocessed_array([
        json.string(x.str_or_int.0),
        json.int(x.str_or_int.1),
      ]),
    ),
  ])
  |> json.to_string
}

pub fn test_tuple2_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestTuple2,
    dynamic.field("str_or_int", dynamic.tuple2(dynamic.string, dynamic.int)),
  )
  |> json.decode(s, _)
}

pub fn test_tuple3_json_encode(x: fixture_test.TestTuple3) {
  json.object([
    #(
      "str_or_int",
      json.preprocessed_array([
        json.string(x.str_or_int.0),
        json.int(x.str_or_int.1),
        json.string(x.str_or_int.2),
      ]),
    ),
  ])
  |> json.to_string
}

pub fn test_tuple3_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestTuple3,
    dynamic.field(
      "str_or_int",
      dynamic.tuple3(dynamic.string, dynamic.int, dynamic.string),
    ),
  )
  |> json.decode(s, _)
}

pub fn test_tuple4_json_encode(x: fixture_test.TestTuple4) {
  json.object([
    #(
      "str_or_int",
      json.preprocessed_array([
        json.string(x.str_or_int.0),
        json.int(x.str_or_int.1),
        json.string(x.str_or_int.2),
        json.int(x.str_or_int.3),
      ]),
    ),
  ])
  |> json.to_string
}

pub fn test_tuple4_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestTuple4,
    dynamic.field(
      "str_or_int",
      dynamic.tuple4(dynamic.string, dynamic.int, dynamic.string, dynamic.int),
    ),
  )
  |> json.decode(s, _)
}

pub fn test_tuple5_json_encode(x: fixture_test.TestTuple5) {
  json.object([
    #(
      "str_or_int",
      json.preprocessed_array([
        json.string(x.str_or_int.0),
        json.int(x.str_or_int.1),
        json.string(x.str_or_int.2),
        json.int(x.str_or_int.3),
        json.string(x.str_or_int.4),
      ]),
    ),
  ])
  |> json.to_string
}

pub fn test_tuple5_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestTuple5,
    dynamic.field(
      "str_or_int",
      dynamic.tuple5(
        dynamic.string,
        dynamic.int,
        dynamic.string,
        dynamic.int,
        dynamic.string,
      ),
    ),
  )
  |> json.decode(s, _)
}

pub fn test_tuple6_json_encode(x: fixture_test.TestTuple6) {
  json.object([
    #(
      "str_or_int",
      json.preprocessed_array([
        json.string(x.str_or_int.0),
        json.int(x.str_or_int.1),
        json.string(x.str_or_int.2),
        json.int(x.str_or_int.3),
        json.string(x.str_or_int.4),
        json.int(x.str_or_int.5),
      ]),
    ),
  ])
  |> json.to_string
}

pub fn test_tuple6_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestTuple6,
    dynamic.field(
      "str_or_int",
      dynamic.tuple6(
        dynamic.string,
        dynamic.int,
        dynamic.string,
        dynamic.int,
        dynamic.string,
        dynamic.int,
      ),
    ),
  )
  |> json.decode(s, _)
}

pub fn test_record_json_encode(x: fixture_test.TestRecord) {
  json.object([
    #("nested", json.object([#("name", json.string(x.nested.name))])),
  ])
  |> json.to_string
}

pub fn test_record_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestRecord,
    dynamic.field(
      "nested",
      dynamic.decode1(
        fixture_test.NestedRecord,
        dynamic.field("name", dynamic.string),
      ),
    ),
  )
  |> json.decode(s, _)
}

pub fn nested_record_json_encode(x: fixture_test.NestedRecord) {
  json.object([#("name", json.string(x.name))])
  |> json.to_string
}

pub fn nested_record_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.NestedRecord,
    dynamic.field("name", dynamic.string),
  )
  |> json.decode(s, _)
}

pub fn test_dict_json_encode(x: fixture_test.TestDict) {
  json.object([
    #(
      "dict",
      json.object(
        x.dict
        |> dict.to_list
        |> list.map(fn(x) { #(x.0, json.int(x.1)) }),
      ),
    ),
  ])
  |> json.to_string
}

pub fn test_dict_json_decode(s: String) {
  dynamic.decode1(
    fixture_test.TestDict,
    dynamic.field("dict", dynamic.dict(dynamic.string, dynamic.int)),
  )
  |> json.decode(s, _)
}
