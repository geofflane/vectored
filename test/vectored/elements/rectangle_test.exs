defmodule Vectored.Elements.RectangleTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Rectangle
  alias Vectored.Renderable

  test "is renderable" do
    assert {:rect, attrs, []} =
             Rectangle.new()
             |> Rectangle.at_location(1, 1)
             |> Rectangle.with_size(10, 10)
             |> Renderable.to_svg()

    assert [{:height, 10}, {:width, 10}, {:x, 1}, {:y, 1}] ==
             attrs
             |> Enum.sort_by(&elem(&1, 0))
  end
end
