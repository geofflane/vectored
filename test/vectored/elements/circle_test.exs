defmodule Vectored.Elements.CircleTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Circle

  doctest Vectored.Elements.Circle

  test "is renderable" do
    assert {:circle, attrs, []} =
             Vectored.Renderable.to_svg(%Circle{cx: 1, cy: 1, r: 5})

    assert attrs == [cx: 1, cy: 1, r: 5]
  end

  test "with_radius/2 updates the radius" do
    circle = Circle.new(5)
    circle = Circle.with_radius(circle, 10)
    assert circle.r == 10
  end
end
