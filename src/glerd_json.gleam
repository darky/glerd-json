import gleam/list
import gleam/string
import glerd/types
import justin
import simplifile

pub fn generate(root, record_info) {
  let imports =
    record_info
    |> list.map(fn(ri) {
      let #(_, module_name, _) = ri
      "import " <> module_name
    })
    |> list.unique
    |> string.join("\n")

  list.fold(record_info, "// this file was generated via glerd_json

    import gleam/json
    import gleam/dynamic

    " <> imports, fn(acc, rinfo) {
    let #(record_name, module_name, record_fields) = rinfo
    let fn_name_prefix = justin.snake_case(record_name)
    let object =
      list.fold(record_fields, "", fn(acc, field) {
        let #(name, typ) = field
        acc <> "#(\"" <> name <> "\", " <> encode_field_type(name, typ) <> "),"
      })

    acc <> "
        pub fn " <> fn_name_prefix <> "_json_encode(x: " <> module_name <> "." <> record_name <> ") {
          json.object([" <> object <> "])
          |> json.to_string
        }
      "
  })
  |> simplifile.write("./" <> root <> "/glerd_json_gen.gleam", _)
}

fn encode_field_type(name, typ) {
  case typ {
    types.IsString if name == "__just_type__" -> "json.string"
    types.IsString -> "json.string(x." <> name <> ")"
    types.IsBool if name == "__just_type__" -> "json.bool"
    types.IsBool -> "json.bool(x." <> name <> ")"
    types.IsInt if name == "__just_type__" -> "json.int"
    types.IsInt -> "json.int(x." <> name <> ")"
    types.IsFloat if name == "__just_type__" -> "json.float(x." <> name <> ")"
    types.IsFloat -> "json.float(x." <> name <> ")"
    types.IsList(typ) -> {
      let nested_type = encode_field_type("__just_type__", typ)
      "json.array(x." <> name <> ", " <> nested_type <> ")"
    }
    types.IsOption(typ) -> {
      let nested_type = encode_field_type("__just_type__", typ)
      "json.nullable(x." <> name <> ", " <> nested_type <> ")"
    }
    x -> panic as { "Type encode not supported: " <> string.inspect(x) }
  }
}
