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
    let #(record_name, module_name, _) = rinfo
    let fn_name_prefix = justin.snake_case(record_name)

    acc <> "
        pub fn " <> fn_name_prefix <> "_json_encode(x: " <> module_name <> "." <> record_name <> ") {
          " <> encode_field_type("", types.IsRecord(record_name), record_info) <> "
          |> json.to_string
        }
      "
  })
  |> simplifile.write("./" <> root <> "/glerd_json_gen.gleam", _)
}

fn encode_field_type(name, typ, record_info) {
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
      let nested_type = encode_field_type("__just_type__", typ, record_info)
      "json.array(x." <> name <> ", " <> nested_type <> ")"
    }
    types.IsOption(typ) -> {
      let nested_type = encode_field_type("__just_type__", typ, record_info)
      "json.nullable(x." <> name <> ", " <> nested_type <> ")"
    }
    types.IsTuple2(typ1, typ2) -> {
      "json.preprocessed_array([
        " <> encode_field_type("__just_type__", typ1, record_info) <> "(x." <> name <> ".0),
        " <> encode_field_type("__just_type__", typ2, record_info) <> "(x." <> name <> ".1)
      ])"
    }
    types.IsTuple3(typ1, typ2, typ3) -> {
      "json.preprocessed_array([
        " <> encode_field_type("__just_type__", typ1, record_info) <> "(x." <> name <> ".0),
        " <> encode_field_type("__just_type__", typ2, record_info) <> "(x." <> name <> ".1),
        " <> encode_field_type("__just_type__", typ3, record_info) <> "(x." <> name <> ".2)
      ])"
    }
    types.IsTuple4(typ1, typ2, typ3, typ4) -> {
      "json.preprocessed_array([
        " <> encode_field_type("__just_type__", typ1, record_info) <> "(x." <> name <> ".0),
        " <> encode_field_type("__just_type__", typ2, record_info) <> "(x." <> name <> ".1),
        " <> encode_field_type("__just_type__", typ3, record_info) <> "(x." <> name <> ".2),
        " <> encode_field_type("__just_type__", typ4, record_info) <> "(x." <> name <> ".3)
      ])"
    }
    types.IsTuple5(typ1, typ2, typ3, typ4, typ5) -> {
      "json.preprocessed_array([
        " <> encode_field_type("__just_type__", typ1, record_info) <> "(x." <> name <> ".0),
        " <> encode_field_type("__just_type__", typ2, record_info) <> "(x." <> name <> ".1),
        " <> encode_field_type("__just_type__", typ3, record_info) <> "(x." <> name <> ".2),
        " <> encode_field_type("__just_type__", typ4, record_info) <> "(x." <> name <> ".3),
        " <> encode_field_type("__just_type__", typ5, record_info) <> "(x." <> name <> ".4)
      ])"
    }
    types.IsTuple6(typ1, typ2, typ3, typ4, typ5, typ6) -> {
      "json.preprocessed_array([
        " <> encode_field_type("__just_type__", typ1, record_info) <> "(x." <> name <> ".0),
        " <> encode_field_type("__just_type__", typ2, record_info) <> "(x." <> name <> ".1),
        " <> encode_field_type("__just_type__", typ3, record_info) <> "(x." <> name <> ".2),
        " <> encode_field_type("__just_type__", typ4, record_info) <> "(x." <> name <> ".3),
        " <> encode_field_type("__just_type__", typ5, record_info) <> "(x." <> name <> ".4),
        " <> encode_field_type("__just_type__", typ6, record_info) <> "(x." <> name <> ".5)
      ])"
    }
    types.IsRecord(record_name) -> {
      let assert Ok(#(_, _, record_fields)) =
        list.find(record_info, fn(ri) {
          let #(rname, _, _) = ri
          rname == record_name
        })
      "json.object(["
      <> list.fold(record_fields, "", fn(acc, field) {
        let #(name, typ) = field
        let ftype = encode_field_type(name, typ, record_info)
        acc <> "#(\"" <> name <> "\", " <> ftype <> "),"
      })
      <> "])"
    }
    x -> panic as { "Type encode not supported: " <> string.inspect(x) }
  }
}
