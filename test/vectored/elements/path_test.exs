defmodule Vectored.Elements.PathTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Path

  test "is renderable" do
    assert {:path, attrs, []} =
             Vectored.Elements.Path.new()
             |> Path.move_to(0, 0)
             |> Path.line_to(10, 10)
             |> Vectored.Renderable.to_svg()

    sorted_attrs = Enum.sort_by(attrs, &elem(&1, 0))
    assert sorted_attrs == [d: "M 0,0 L 10,10"]
  end

  defp d(path) do
    {:path, attrs, []} = Vectored.Renderable.to_svg(path)
    Keyword.fetch!(attrs, :d)
  end

  test "quadratic_bezier_curve emits Q with one control point and an endpoint" do
    path = Path.new() |> Path.move_to(0, 0) |> Path.quadratic_bezier_curve(5, 5, 10, 0)
    assert d(path) == "M 0,0 Q 5,5 10,0"
  end

  test "smooth_quadratic_curve emits T with only the endpoint" do
    # SVG's T command infers the control point; it takes only x,y.
    path = Path.new() |> Path.move_to(0, 0) |> Path.smooth_quadratic_curve(10, 0)
    assert d(path) == "M 0,0 T 10,0"
  end

  test "smooth_quadratic_curve uses lowercase t when relative" do
    path = Path.new() |> Path.move_to(0, 0) |> Path.smooth_quadratic_curve(10, 0, true)
    assert d(path) == "M 0,0 t 10,0"
  end

  test "cubic_bezier_curve emits C with two control points and an endpoint" do
    path = Path.new() |> Path.move_to(0, 0) |> Path.cubic_bezier_curve(0, 5, 10, 5, 10, 0)
    assert d(path) == "M 0,0 C 0,5 10,5 10,0"
  end

  test "smooth_bezier_curve emits S with one control point and an endpoint" do
    # SVG's S command infers the first control point; it takes x2,y2 and the endpoint.
    path = Path.new() |> Path.move_to(0, 0) |> Path.smooth_bezier_curve(10, 5, 10, 0)
    assert d(path) == "M 0,0 S 10,5 10,0"
  end

  test "smooth_bezier_curve uses lowercase s when relative" do
    path = Path.new() |> Path.move_to(0, 0) |> Path.smooth_bezier_curve(10, 5, 10, 0, true)
    assert d(path) == "M 0,0 s 10,5 10,0"
  end
end
