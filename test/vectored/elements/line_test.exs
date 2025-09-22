defmodule Vectored.Elements.LineTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Line
  alias Vectored.Renderable

  test "is renderable" do
    assert {:line, attrs, []} =
             Line.new()
             |> Line.from(1, 1)
             |> Line.to(10, 10)
             |> Renderable.to_svg()

    assert [{:x1, 1}, {:x2, 10}, {:y1, 1}, {:y2, 10}] ==
             attrs
             |> Enum.sort_by(&elem(&1, 0))
  end
end
