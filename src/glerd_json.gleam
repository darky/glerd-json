import gleam/list
import glerd/types
import justin
import simplifile

pub fn generate(root, record_info) {
  list.fold(
    record_info,
    "// this file was generated via glerd_json

    import gleam/json
    import gleam/dynamic

    ",
    fn(acc, rinfo) {
      let #(record_name, record_fields) = rinfo
      let record_name = justin.snake_case(record_name)
      let object =
        list.fold(record_fields, "", fn(acc, field) {
          let #(name, typ) = field
          acc <> "#(\"" <> name <> "\", " <> field_type(name, typ) <> ")"
        })
      acc <> "
        pub fn " <> record_name <> "_json_encode(x) {
          json.object([" <> object <> "])
          |> json.to_string
        }
      "
    },
  )
  |> simplifile.write("./" <> root <> "/glerd_json_gen.gleam", _)
}

fn field_type(name, typ) {
  case typ {
    types.IsString -> "json.string(x." <> name <> ")"
    types.IsBool -> "json.bool(x." <> name <> ")"
    types.IsInt -> "json.int(x." <> name <> ")"
    types.IsFloat -> "json.float(x." <> name <> ")"
    types.IsList(typ) ->
      "json.array(x." <> name <> ", " <> field_type(name, typ) <> ")"
    _ -> ""
  }
}
