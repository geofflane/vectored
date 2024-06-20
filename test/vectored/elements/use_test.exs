defmodule Vectored.Elements.UseTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Use
  alias Vectored.Renderable

  test "is renderable" do
    assert {:use, attrs, []} =
      Use.new("#foo")
      |> Use.at_location(1, 1)
      |> Use.with_size(10, 10)
      |> Renderable.to_svg()

    assert [{:height, 10}, {:href, "#foo"}, {:width, 10}, {:x, 1}, {:y, 1}] ==
      attrs
      |> Enum.sort_by(& elem(&1, 0))

  end
end
