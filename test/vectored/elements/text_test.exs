defmodule Vectored.Elements.TextTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Text
  alias Vectored.Renderable

  test "is renderable" do
    assert {:text, attrs, _content} =
      Text.new(1, 1, "Test")
      |> Renderable.to_svg()

    assert [{:x, 1}, {:y, 1}] ==
      attrs
      |> Enum.sort_by(& elem(&1, 0))

  end
end
