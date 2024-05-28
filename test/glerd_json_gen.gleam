// this file was generated via glerd_json

import gleam/dynamic
import gleam/json

import fixture_test

pub fn test_string_json_encode(x: fixture_test.TestString) {
  json.object([#("name", json.string(x.name))])
  |> json.to_string
}

pub fn test_int_json_encode(x: fixture_test.TestInt) {
  json.object([#("age", json.int(x.age))])
  |> json.to_string
}

pub fn test_float_json_encode(x: fixture_test.TestFloat) {
  json.object([#("distance", json.float(x.distance))])
  |> json.to_string
}

pub fn test_bool_json_encode(x: fixture_test.TestBool) {
  json.object([#("is_exists", json.bool(x.is_exists))])
  |> json.to_string
}

pub fn test_multiple_json_encode(x: fixture_test.TestMultiple) {
  json.object([#("name", json.string(x.name)), #("age", json.int(x.age))])
  |> json.to_string
}

pub fn test_list_json_encode(x: fixture_test.TestList) {
  json.object([#("names", json.array(x.names, json.string))])
  |> json.to_string
}

pub fn test_option_json_encode(x: fixture_test.TestOption) {
  json.object([#("some_int", json.nullable(x.some_int, json.int))])
  |> json.to_string
}
