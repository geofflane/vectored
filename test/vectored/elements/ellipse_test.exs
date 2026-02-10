defmodule Vectored.Elements.EllipseTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Ellipse

  test "is renderable" do
    assert {:ellipse, attrs, []} =
             Vectored.Renderable.to_svg(Ellipse.new(10, 20, 5, 8))

    sorted_attrs = Enum.sort_by(attrs, &elem(&1, 0))

    # We expect cx, cy, rx, ry. New elements should follow the cx/cy pattern of circle for consistency.
    # Wait, SVG ellipse uses cx, cy, rx, ry.
    assert sorted_attrs == [cx: 10, cy: 20, rx: 5, ry: 8]
  end

  test "with setters" do
    ellipse =
      Ellipse.new(5, 5)
      |> Ellipse.at_location(10, 20)

    assert ellipse.cx == 10
    assert ellipse.cy == 20
    assert ellipse.rx == 5
    assert ellipse.ry == 5
  end
end
