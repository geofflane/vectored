defmodule Vectored.Elements.PolylineTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Polyline

  doctest Vectored.Elements.Polyline

  test "is renderable" do
    assert {:polyline, attrs, []} =
             Polyline.new([{1, 2}, {3, 4}])
             |> Vectored.Renderable.to_svg()

    assert attrs == [points: "1,2 3,4"]
  end
end
