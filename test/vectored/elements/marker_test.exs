defmodule Vectored.Elements.MarkerTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Marker
  alias Vectored.Renderable

  test "is renderable" do
    assert {:marker, attrs, []} =
             Marker.new()
             |> Marker.size(2, 2)
             |> Marker.orient(0)
             |> Renderable.to_svg()

    assert [{:markerHeight, 2}, {:markerWidth, 2}, {:orient, 0}, {:refX, 0}, {:refY, 0}] ==
             attrs
             |> Enum.sort_by(&elem(&1, 0))
  end
end
