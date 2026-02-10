# Vectored

![Tests](https://github.com/geofflane/vectored/actions/workflows/elixir.yml/badge.svg)

`Vectored` is a lightweight, extensible Elixir library for generating SVG images programmatically. It leverages Erlang's built-in `:xmerl` for XML generation, ensuring no heavy external dependencies while providing a fluent, Elixir-native API.

## Pros and Cons

### Pros

* **Zero Runtime Dependencies**: Only depends on Elixir and Erlang/OTP (using built-in `:xmerl`).
* **Fluent API**: Easily pipe attribute setters (`with_fill`, `with_stroke`, etc.) to build complex elements.
* **Extensible**: Use the `defelement` macro to create your own SVG elements or implement the `Vectored.Renderable` protocol.
* **Accessibility & Interop**: Built-in support for `<title>`/`<desc>` and `data-*` attributes for frontend framework integration.

### Cons

* **Low-Level**: This library does not provide high-level abstractions (like "BarChart" or "Icon"). It is a thin wrapper over the SVG specification.
* **Requires SVG Knowledge**: You need to understand how SVG coordinates, viewboxes, and element nesting work.
* **No Validation**: The library doesn't prevent you from setting invalid attribute values (e.g., `with_fill("not-a-color")`) or nesting elements incorrectly according to the SVG spec.
* **Verbosity**: Building complex scenes involves a lot of Elixir code compared to writing raw XML or using a templating engine.

## Installation

Add it to your `mix.exs`:

```elixir
def deps do
  [
    {:vectored, git: "https://github.com/geofflane/vectored.git", tag: "0.4.0"}
  ]
end
```

## Quick Start

```elixir
alias Vectored.Elements.{Svg, Circle, Rectangle, Stop, LinearGradient}

# Create a simple SVG with a gradient-filled circle
{:ok, svg_string} =
  Vectored.new()
  |> Svg.with_size(200, 200)
  |> Svg.append_defs(
    LinearGradient.new([
      Stop.new("0%", "red"),
      Stop.new("100%", "blue")
    ]) |> LinearGradient.with_id("my_grad")
  )
  |> Svg.append(
    Circle.new(100, 100, 80)
    |> Circle.with_fill("url(#my_grad)")
  )
  |> Vectored.to_svg_string()
```

## Advanced Examples

### Complex Paths

Vectored provides a dedicated `Path` DSL for building complex shapes:

```elixir
alias Vectored
alias Vectored.Elements.{Path, Svg}

{:ok, svg} =
    Vectored.new()
    |> Svg.with_view_box(100, 100)
    |> Svg.append(fn ->
        Path.new()
        |> Path.move_to(10, 30)
        |> Path.eliptical_arc_curve(20, 20, 0, 0, 1, 50, 30)
        |> Path.eliptical_arc_curve(20, 20, 0, 0, 1, 90, 30)
        |> Path.quadratic_bezier_curve(90, 60, 50, 90)
        |> Path.quadratic_bezier_curve(10, 60, 10, 30)
        |> Path.close_path()
    end)
    |> Vectored.to_svg_string()
```

Creates an SVG image:

![Example generated SVG](docs/heart.svg)

### Programmatic Example

```elixir
defmodule FieldDiagram do
  alias Vectored
  alias Vectored.Elements.{Circle, Defs, Group, Line, Marker, Path, Polyline, Svg, Use}

  @width 160
  @height 300
  @image_los_offset 12
  @hash_offset 70.75
  @hash_width 2
  @hash_stroke 0.5

  @doc """
  Generate an SVG that is a slice of the field to show motions
  """
  @spec generate_svg(number(), number()) :: {:ok, String.t()} | {:error, term()}
  def generate_svg(width, height) do

    Vectored.new()
    |> Svg.with_view_box(width, height)
    |> Svg.with_style("background-color: #eee")
    |> with_field()
    |> Vectored.to_svg_string()
  end

  # This builds the hashmarks and whatnot
  defp with_field(svg) do
    Svg.append(svg, fn ->
     Group.new()
      |> Group.with_id("field")
      |> Group.append(yard_markers())
      |> Group.append(los())
    end)
  end

  defp los() do
    Line.new()
    |> Line.from(0, @image_los_offset)
    |> Line.to(@width, @image_los_offset)
    |> Line.with_stroke("yellow")
    |> Line.with_stroke_width(1)
  end

  def yard_markers() do
    Enum.flat_map(0..@height//3, fn y ->
      if rem(y, 15) == 0 do
        Line.new()
        |> Line.from(0, y)
        |> Line.to(@width, y)
        |> Line.with_stroke("white")
        |> Line.with_stroke_width(1)
        |> List.wrap()
      else
        # Hash marks
        h1 =
          Line.new()
          |> Line.from(@hash_offset, y)
          |> Line.to(@hash_offset + @hash_width, y)
          |> Line.with_stroke("white")
          |> Line.with_stroke_width(@hash_stroke)

        h2 =
          Line.new()
          |> Line.from(@width - @hash_offset, y)
          |> Line.to(@width - @hash_offset - @hash_width, y)
          |> Line.with_stroke("white")
          |> Line.with_stroke_width(@hash_stroke)

        [h1, h2]
      end
    end)
  end
end

with {:ok, svg} <- FieldDiagram.generate_svg(160, 60) do
  File.write!("field.svg", svg)
end
```

![Generated Field SVG](docs/field.svg)

## Seeing it in Action (Kitchen Sink)

To see a comprehensive demonstration of all supported SVG elements and attributes, you can run the integration "Kitchen Sink" test. This will generate a `kitchen_sink.svg` file in your project root.

```bash
mix test test/vectored/integration/kitchen_sink_test.exs --include manual
```

This image serves as a visual specification of the library's capabilities, including gradients, masks, symbols, and text styling.

## Features & Supported Elements

* **Shapes**: `Circle`, `Rectangle`, `Ellipse`, `Line`, `Polyline`, `Polygon`.
* **Text**: `Text`, `Tspan`.
* **Structure**: `Group` (g), `Defs`, `Use`, `Symbol`, `Marker`.
* **Composition**: `ClipPath`, `Mask`.
* **Aesthetics**: `LinearGradient`, `RadialGradient`, `Pattern`, `Image`.

## TODO

* Validate attributes (types, required, etc)
* More SVG structures
* More extensive tests (test xml output with xpath?)

## Copyright and License

Copyright (c) 2024, Geoff Lane.

Source code is licensed under the MIT License.
