defmodule Vectored.Elements.CircleTest do
  use ExUnit.Case, async: true

  test "is renderable" do
    assert {:circle, attrs, []} = Vectored.Renderable.to_svg(%Vectored.Elements.Circle{cx: 1, cy: 1, r: 5})

    sorted_attrs = Enum.sort_by(attrs, & elem(&1, 0))
    assert sorted_attrs == [cx: 1, cy: 1, r: 5]
  end
end
