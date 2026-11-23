defmodule Vectored.Elements.PolygonTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Polygon

  doctest Vectored.Elements.Polygon

  test "is renderable" do
    assert {:polygon, attrs, []} =
             Polygon.new([{1, 2}, {3, 4}])
             |> Vectored.Renderable.to_svg()

    sorted_attrs = Enum.sort_by(attrs, &elem(&1, 0))
    assert sorted_attrs == [points: "1,2 3,4"]
  end
end
