# glerd_json

[![Package Version](https://img.shields.io/hexpm/v/glerd_json)](https://hex.pm/packages/glerd_json)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glerd_json/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Gleam JSON encoders/decoders codegen using Glerd

```sh
gleam add --dev glerd glerd_json
```

#### 1. Generate types info

Use [Glerd](https://github.com/darky/glerd)

#### 2. Make module for JSON generation

###### my_module.gleam

```gleam
import glerd_json
import glerd_gen

pub fn main() {
  glerd_gen.record_info
  |> glerd_json.generate("src", _)
}
```

#### 3. Gen JSON encoders/decoders

```sh
gleam run -m my_module
```

Further documentation can be found at <https://hexdocs.pm/glerd_json>.

## Development

```sh
gleam test # and then commit generated file
```
