defmodule Vectored.Elements.PolygonTest do
  use ExUnit.Case, async: true

  test "is renderable" do
    assert {:polygon, attrs, []} =
      Vectored.Elements.Polygon.new([{1, 2}, {3, 4}])
      |> Vectored.Renderable.to_svg()

    sorted_attrs = Enum.sort_by(attrs, & elem(&1, 0))
    assert sorted_attrs == [points: "1,2 3,4"]
  end
end
