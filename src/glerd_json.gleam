import gleam/dict
import gleam/int
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

  let record_info_dict =
    list.fold(record_info, dict.new(), fn(acc, ri) {
      let #(name, _, _) = ri
      dict.insert(acc, name, ri)
    })

  list.fold(record_info, "// this file was generated via glerd_json

    import gleam/json
    import gleam/dynamic

    " <> imports, fn(acc, rinfo) {
    let #(record_name, module_name, _) = rinfo
    let fn_name_prefix = justin.snake_case(record_name)
    let object =
      encode_field_type("", types.IsRecord(record_name), record_info_dict)

    acc <> "
        pub fn " <> fn_name_prefix <> "_json_encode(x: " <> module_name <> "." <> record_name <> ") {
          " <> object <> "
          |> json.to_string
        }
      "
  })
  |> simplifile.write("./" <> root <> "/glerd_json_gen.gleam", _)
}

fn encode_field_type(name, typ, record_info_dict) {
  case typ {
    types.IsString if name == "__just_type__" -> "json.string"
    types.IsString -> "json.string(x" <> name <> ")"
    types.IsBool if name == "__just_type__" -> "json.bool"
    types.IsBool -> "json.bool(x" <> name <> ")"
    types.IsInt if name == "__just_type__" -> "json.int"
    types.IsInt -> "json.int(x" <> name <> ")"
    types.IsFloat if name == "__just_type__" -> "json.float(x" <> name <> ")"
    types.IsFloat -> "json.float(x" <> name <> ")"
    types.IsList(typ) -> {
      let nested_type =
        encode_field_type("__just_type__", typ, record_info_dict)
      "json.array(x" <> name <> ", " <> nested_type <> ")"
    }
    types.IsOption(typ) -> {
      let nested_type =
        encode_field_type("__just_type__", typ, record_info_dict)
      "json.nullable(x" <> name <> ", " <> nested_type <> ")"
    }
    types.IsTuple2(typ1, typ2) -> {
      encode_tuple(name, [typ1, typ2], record_info_dict)
    }
    types.IsTuple3(typ1, typ2, typ3) -> {
      encode_tuple(name, [typ1, typ2, typ3], record_info_dict)
    }
    types.IsTuple4(typ1, typ2, typ3, typ4) -> {
      encode_tuple(name, [typ1, typ2, typ3, typ4], record_info_dict)
    }
    types.IsTuple5(typ1, typ2, typ3, typ4, typ5) -> {
      encode_tuple(name, [typ1, typ2, typ3, typ4, typ5], record_info_dict)
    }
    types.IsTuple6(typ1, typ2, typ3, typ4, typ5, typ6) -> {
      encode_tuple(name, [typ1, typ2, typ3, typ4, typ5, typ6], record_info_dict)
    }
    types.IsRecord(record_name) -> {
      let assert Ok(#(_, _, record_fields)) =
        dict.get(record_info_dict, record_name)

      "json.object(["
      <> list.fold(record_fields, "", fn(acc, field) {
        let #(fname, typ) = field
        let ftype =
          encode_field_type(name <> "." <> fname, typ, record_info_dict)
        acc <> "#(\"" <> fname <> "\", " <> ftype <> "),"
      })
      <> "])"
    }
    types.IsResult(typ_ok, typ_err) -> {
      let typ_ok = encode_field_type("", typ_ok, record_info_dict)
      let typ_err = encode_field_type("", typ_err, record_info_dict)
      "json.object({
        case x" <> name <> " {
          Ok(x) -> [#(\"ok\", " <> typ_ok <> ")]
          Error(x) -> [#(\"error\", " <> typ_err <> ")]
        }
      })"
    }
    x -> panic as { "Type encode not supported: " <> string.inspect(x) }
  }
}

fn encode_tuple(name, types, record_info_dict) {
  let tuple_body =
    types
    |> list.index_map(fn(typ, i) {
      let typ = encode_field_type("__just_type__", typ, record_info_dict)
      typ <> "(x" <> name <> "." <> int.to_string(i) <> "),"
    })
    |> string.join("\n")
  "json.preprocessed_array([" <> tuple_body <> "])"
}
