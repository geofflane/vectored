defmodule VectoredTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Circle, Group, Path, Text, Svg, Use}

  test "can render svg" do
    group =
      Group.new()
      |> Group.append(Circle.new(1, 1, 5))
      |> Group.append(Text.new(1, 1, "test"))

    assert _svg =
      Svg.new(100, 100)
      |> Svg.append(group)
      |> Vectored.to_svg()
  end

  test "can render xml" do
    group =
      Group.new()
      |> Group.append(Circle.new(1, 1, 5))
      |> Group.append(Text.new(1, 1, "test"))

    assert {:ok, svg} =
      Svg.new(100, 100)
      |> Svg.append(group)
      |> Vectored.to_svg_string()

    assert "<svg width=\"100\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><g><circle r=\"5\" cx=\"1\" cy=\"1\"/><text y=\"1\" x=\"1\">test</text></g></svg>" == svg
  end

  test "can render xml with defs" do
    assert {:ok, svg} =
      Svg.new(100, 100)
      |> Svg.append_defs([%Circle{id: "circle", r: 5}])
      |> Svg.append([
        Use.new("#circle", 10, 10),
        Use.new("#circle", 20, 10),
        Use.new("#circle", 30, 10),
      ])
      |> Vectored.to_svg_string()

    assert "<svg width=\"100\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><defs><circle id=\"circle\" r=\"5\" cx=\"0\" cy=\"0\"/></defs><use y=\"10\" x=\"10\" href=\"#circle\"/><use y=\"10\" x=\"20\" href=\"#circle\"/><use y=\"10\" x=\"30\" href=\"#circle\"/></svg>" == svg
  end

  test "can render line paths" do
    path =
      Path.new()
      |> Path.with_stroke("red")
      |> Path.with_fill("none")
      |> Path.move_to(10, 10)
      |> Path.line_to(90, 90)
      |> Path.vertical_line_to(10)
      |> Path.horizontal_line_to(50)

    assert {:ok, svg} =
      Svg.new(100, 100, [path])
      |> Vectored.to_svg_string()

    assert svg
  end
end
