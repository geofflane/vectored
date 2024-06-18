defmodule Vectored.Elements.PathTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Path

  test "is renderable" do
    assert {:path, attrs, []} =
      Vectored.Elements.Path.new()
      |> Path.move_to(0, 0)
      |> Path.line_to(10, 10)
      |> Vectored.Renderable.to_svg()

    sorted_attrs = Enum.sort_by(attrs, & elem(&1, 0))
    assert sorted_attrs == [d: "M 0,0 L 10,10"]
  end
end
