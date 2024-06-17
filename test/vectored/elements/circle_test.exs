defmodule Vectored.Elements.CircleTest do
  use ExUnit.Case, async: true

  test "is renderable" do
    assert {:circle, [r: 5, cx: 1, cy: 1, stroke: "black", fill: "white", "stroke-width": 5], []}
      == Vectored.Renderable.to_svg(%Vectored.Elements.Circle{cx: 1, cy: 1, r: 5})
  end
end
