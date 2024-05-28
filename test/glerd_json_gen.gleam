// this file was generated via glerd_json

import gleam/dynamic
import gleam/json

pub fn test_string_json_encode(x) {
  json.object([#("name", json.string(x.name))])
  |> json.to_string
}
