defmodule Vectored.Integration.KitchenSinkTest do
  use ExUnit.Case, async: true

  alias Vectored.Elements.{
    Circle,
    ClipPath,
    Defs,
    Ellipse,
    Group,
    Image,
    Line,
    LinearGradient,
    Marker,
    Mask,
    Path,
    Pattern,
    Polygon,
    Polyline,
    RadialGradient,
    Rectangle,
    Stop,
    Svg,
    Symbol,
    Text,
    Tspan,
    Use
  }

  @tag :manual
  test "generates a comprehensive kitchen sink SVG" do
    # 1. Define reusable elements in Defs
    defs =
      Defs.new([])
      |> Defs.append(
        LinearGradient.new([
          Stop.new("0%", "blue"),
          Stop.new("100%", "transparent")
        ])
        |> LinearGradient.with_id("lin_grad")
        |> LinearGradient.with_coordinates(0, 0, 1, 0)
      )
      |> Defs.append(
        RadialGradient.new([
          Stop.new("0%", "yellow"),
          Stop.new("100%", "red")
        ])
        |> RadialGradient.with_id("rad_grad")
        |> RadialGradient.with_center(0.5, 0.5, 0.5)
      )
      |> Defs.append(
        Pattern.new([
          Circle.new(2, 2, 1) |> Circle.with_fill("black")
        ])
        |> Pattern.with_id("dot_pattern")
        |> Pattern.with_size(4, 4)
        |> Pattern.with_pattern_units("userSpaceOnUse")
      )
      |> Defs.append(
        ClipPath.new([
          Circle.new(25, 25, 20)
        ])
        |> ClipPath.with_id("circle_clip")
      )
      |> Defs.append(
        Mask.new([
          Rectangle.new(0, 0, 50, 50)
          |> Rectangle.with_fill("white")
          |> Rectangle.with_opacity(0.5)
        ])
        |> Mask.with_id("semi_mask")
      )
      |> Defs.append(
        Marker.new()
        |> Marker.with_id("arrow")
        |> Marker.size(10, 10)
        |> Marker.ref(0, 5)
        |> Marker.orient("auto")
        |> Marker.with_shape(
          Path.new()
          |> Path.move_to(0, 0)
          |> Path.line_to(10, 5)
          |> Path.line_to(0, 10)
          |> Path.close_path()
        )
      )
      |> Defs.append(
        Symbol.new([
          Path.new()
          |> Path.move_to(10, 10)
          |> Path.line_to(40, 10)
          |> Path.line_to(25, 40)
          |> Path.close_path()
          |> Path.with_fill("purple")
        ])
        |> Symbol.with_id("triangle_sym")
        |> Symbol.with_view_box(0, 0, 50, 50)
      )

    # 2. Build the main document
    svg =
      Svg.new(800, 1000)
      |> Svg.with_view_box(0, 0, 800, 1000)
      |> Svg.with_style("background-color: #f0f0f0")
      |> Svg.append_defs(defs)
      |> Svg.append(
        Text.new(400, 40, "Vectored Kitchen Sink Integration Test")
        |> Text.with_text_anchor("middle")
        |> Text.with_font_size(24)
        |> Text.with_font_weight("bold")
      )
      # Row 1: Basic Shapes
      |> Svg.append(
        Group.new([
          Text.new(
            10,
            80,
            "Basic Shapes: Circle, Rect (rounded), Ellipse, Line, Polyline, Polygon"
          )
          |> Text.with_font_size(14),
          Circle.new(50, 150, 30) |> Circle.with_fill("red") |> Circle.with_stroke("black"),
          Rectangle.new(100, 120, 60, 60)
          |> Rectangle.with_rx(10)
          |> Rectangle.with_ry(10)
          |> Rectangle.with_fill("green"),
          Ellipse.new(220, 150, 40, 20) |> Ellipse.with_fill("blue"),
          Line.new()
          |> Line.from(300, 120)
          |> Line.to(350, 180)
          |> Line.with_stroke("black")
          |> Line.with_stroke_width(2),
          Polyline.new([{380, 180}, {400, 120}, {420, 180}, {440, 120}])
          |> Polyline.with_fill("none")
          |> Polyline.with_stroke("orange")
          |> Polyline.with_stroke_width(3),
          Polygon.new([{480, 180}, {510, 120}, {540, 180}]) |> Polygon.with_fill("cyan")
        ])
      )
      # Row 2: Fills, Gradients, Patterns
      |> Svg.append(
        Group.new([
          Text.new(10, 250, "Fills: Linear Gradient, Radial Gradient, Dot Pattern, Opacity")
          |> Text.with_font_size(14),
          Rectangle.new(20, 270, 100, 50) |> Rectangle.with_fill("url(#lin_grad)"),
          Circle.new(180, 295, 30) |> Circle.with_fill("url(#rad_grad)"),
          Rectangle.new(250, 270, 100, 50) |> Rectangle.with_fill("url(#dot_pattern)"),
          Rectangle.new(380, 270, 50, 50)
          |> Rectangle.with_fill("black")
          |> Rectangle.with_opacity(0.3)
        ])
      )
      # Row 3: Advanced Composition
      |> Svg.append(
        Group.new([
          Text.new(10, 400, "Composition: ClipPath (circle), Mask (alpha), Symbol/Use")
          |> Text.with_font_size(14),
          # Clipped image
          Rectangle.new(20, 420, 50, 50)
          |> Rectangle.with_fill("gold")
          |> Rectangle.with_clip_path("url(#circle_clip)"),
          # Masked rect
          Rectangle.new(100, 420, 50, 50)
          |> Rectangle.with_fill("red")
          |> Rectangle.with_mask("url(#semi_mask)"),
          # Use symbol
          Use.new("#triangle_sym", 180, 420) |> Use.with_size(50, 50),
          # Nested text with Tspan
          Text.new(300, 450, "Styled ")
          |> Text.append(
            Tspan.new("Text ")
            |> Tspan.with_fill("red")
            |> Tspan.with_font_weight("bold")
          )
          |> Text.append(Tspan.new("with Tspan") |> Tspan.with_font_style("italic"))
        ])
      )
      # Row 4: Path & Markers
      |> Svg.append(
        Group.new([
          Text.new(10, 550, "Path & Markers: Complex curve with an arrowhead marker")
          |> Text.with_font_size(14),
          Path.new()
          |> Path.move_to(20, 600)
          |> Path.cubic_bezier_curve(50, 550, 150, 650, 200, 600)
          |> Path.with_stroke("black")
          |> Path.with_fill("none")
          |> Path.with_marker_end("url(#arrow)")
          |> Path.with_stroke_width(2)
        ])
      )
      # Row 5: Dataset & Transforms
      |> Svg.append(
        Group.new([
          Text.new(10, 700, "Extras: Data attributes, Transforms (rotate)")
          |> Text.with_font_size(14),
          Rectangle.new(20, 720, 40, 40)
          |> Rectangle.with_fill("brown")
          |> Rectangle.put_dataset(:testId, "rect-1")
          |> Rectangle.with_transform("rotate(45 40 740)")
        ])
      )
      # Image placeholder
      |> Svg.append(
        Group.new([
          Text.new(10, 850, "Image Element: An external placeholder image")
          |> Text.with_font_size(14),
          Image.new(20, 870, 100, 100, "https://via.placeholder.com/100")
        ])
      )

    # 3. Generate and write
    {:ok, svg_string} = Vectored.to_svg_string(svg)

    # Write to root
    File.write!("kitchen_sink.svg", svg_string)

    IO.puts("\nGenerated kitchen_sink.svg in the root directory.")
    IO.puts("Expected Visuals:")

    IO.puts(
      "- Row 1: Red circle, rounded green square, blue oval, black line, orange zig-zag, cyan triangle."
    )

    IO.puts(
      "- Row 2: Blue-to-transparent rect, yellow/red radial circle, dotted rect, translucent black square."
    )

    IO.puts(
      "- Row 3: Gold square clipped to circle, red square partially transparent, purple triangle (reused symbol), multi-colored text."
    )

    IO.puts("- Row 4: A curved line ending in a black arrowhead.")
    IO.puts("- Row 5: A rotated brown square.")
    IO.puts("- Row 6: A 100x100 placeholder image.")

    assert File.exists?("kitchen_sink.svg")
  end
end
