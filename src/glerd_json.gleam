import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import gleamyshell
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

  let gen_content =
    list.fold(record_info, "// this file was generated via glerd_json

    import gleam/json
    import gleam/dynamic
    import gleam/dict
    import gleam/list

    " <> imports, fn(acc, rinfo) {
      let #(record_name, module_name, _) = rinfo
      let fn_name_prefix = justin.snake_case(record_name)
      let encoded =
        encode_field_type("", types.IsRecord(record_name), record_info_dict)
      let decoded =
        decode_field_type(types.IsRecord(record_name), record_info_dict)

      acc <> "
        pub fn " <> fn_name_prefix <> "_json_encode(x: " <> module_name <> "." <> record_name <> ") {
          " <> encoded <> "
          |> json.to_string
        }

        pub fn " <> fn_name_prefix <> "_json_decode(s: String) {
          " <> decoded <> "
          |> json.decode(s, _)
        }
      "
    })

  let gen_file_path = "./" <> root <> "/glerd_json_gen.gleam"

  let assert Ok(_) = simplifile.write(gen_file_path, gen_content)

  let assert Ok(_) =
    gleamyshell.execute("gleam", ".", ["format", gen_file_path])

  Nil
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
    types.IsDict(_, val_typ) -> {
      let val_typ =
        encode_field_type("__just_type__", val_typ, record_info_dict)
      "json.object(
        x" <> name <> "
        |> dict.to_list
        |> list.map(fn(x) {
          #(x.0," <> val_typ <> "(x.1))
        })
      )"
    }
    x -> panic as { "Type encode not supported: " <> string.inspect(x) }
  }
}

fn decode_field_type(typ, record_info_dict) {
  case typ {
    types.IsString -> "dynamic.string"
    types.IsInt -> "dynamic.int"
    types.IsFloat -> "dynamic.float"
    types.IsBool -> "dynamic.bool"
    types.IsList(typ) ->
      "dynamic.list(" <> decode_field_type(typ, record_info_dict) <> ")"
    types.IsOption(typ) ->
      "dynamic.optional(" <> decode_field_type(typ, record_info_dict) <> ")"
    types.IsResult(typ, err_typ) -> "dynamic.any([
        dynamic.field(\"ok\", " <> decode_field_type(typ, record_info_dict) <> "),
        dynamic.field(\"error\", " <> decode_field_type(
        err_typ,
        record_info_dict,
      ) <> ")
      ])"
    types.IsDict(key_typ, val_typ) ->
      "dynamic.dict("
      <> decode_field_type(key_typ, record_info_dict)
      <> ", "
      <> decode_field_type(val_typ, record_info_dict)
      <> ")"
    types.IsTuple2(typ1, typ2) -> decode_tuple([typ1, typ2], record_info_dict)
    types.IsTuple3(typ1, typ2, typ3) ->
      decode_tuple([typ1, typ2, typ3], record_info_dict)
    types.IsTuple4(typ1, typ2, typ3, typ4) ->
      decode_tuple([typ1, typ2, typ3, typ4], record_info_dict)
    types.IsTuple5(typ1, typ2, typ3, typ4, typ5) ->
      decode_tuple([typ1, typ2, typ3, typ4, typ5], record_info_dict)
    types.IsTuple6(typ1, typ2, typ3, typ4, typ5, typ6) ->
      decode_tuple([typ1, typ2, typ3, typ4, typ5, typ6], record_info_dict)
    types.IsRecord(record_name) -> {
      let assert Ok(#(_, module_name, record_fields)) =
        dict.get(record_info_dict, record_name)
      let arity = list.length(record_fields) |> int.to_string()

      "dynamic.decode" <> arity <> "(
        " <> module_name <> "." <> record_name <> ",
        " <> list.map(record_fields, fn(x) {
        let #(fname, typ) = x
        "dynamic.field(\""
        <> fname
        <> "\", "
        <> decode_field_type(typ, record_info_dict)
        <> ")"
      })
      |> string.join(",\n") <> "
      )"
    }
    x -> panic as { "Type decode not supported: " <> string.inspect(x) }
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

fn decode_tuple(types, record_info_dict) {
  let arity = list.length(types) |> int.to_string
  let body =
    types
    |> list.map(fn(typ) { decode_field_type(typ, record_info_dict) })
    |> string.join(",")
  "dynamic.tuple" <> arity <> "(" <> body <> ")"
}
