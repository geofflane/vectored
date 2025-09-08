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

    assert {:svg, _attrs, [{:g, [], group_children}]} =
      Svg.new(100, 100)
      |> Svg.append(group)
      |> Vectored.to_svg()

    assert [
      {:circle, _attrs1, []},
      {:text, _attrs2, [_]},
    ] = group_children
  end

  test "can render xml with defs" do
    assert {:svg, _attrs, [{:defs, [], _def_children} | _uses]} =
      Svg.new(100, 100)
      |> Svg.append_defs([%Circle{id: "circle", r: 5}])
      |> Svg.append([
        Use.new("#circle", 10, 10),
        Use.new("#circle", 20, 10),
        Use.new("#circle", 30, 10),
      ])
      |> Vectored.to_svg()
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

    assert {:svg, _attrs, [{:path, attrs, []}]} =
      Svg.new(100, 100, [path])
      |> Vectored.to_svg()

    assert [{:d, path_attrs}, {:fill, _}, {:stroke, _}] =
      attrs
      |> Enum.sort_by(& elem(&1, 0))

    assert path_attrs == "M 10,10 L 90,90 V 10 H 50"
  end

  test "can render desc and title" do
    assert {:circle, _attrs, children} =
      Circle.new(10)
      |> Circle.with_description("I'm a circle")
      |> Circle.with_title("testing circle")
      |> Vectored.to_svg()

    assert [{:desc, [], _}, {:title, [], _}] =
      children
      |> Enum.sort_by(& elem(&1, 0))
  end

  describe "private data" do
    test "empty state, does not get rendered" do
      svg = Svg.new()
      assert svg.private == %{}
      assert Vectored.to_svg(svg) == {:svg, [], []}
    end

    test "can have privatedata, but doesn't render it" do
      svg = 
        Svg.new()
        |> Svg.with_private(%{a: 1, b: 2})
        |> Svg.put_private(:c, 3)
        |> Svg.delete_private(:b)
  
      assert %{a: 1, c: 3} = svg.private
      assert Vectored.to_svg(svg) == {:svg, [], []}
    end
  end
end
