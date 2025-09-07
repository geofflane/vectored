defmodule Vectored.Elements.TextTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Text
  alias Vectored.Renderable

  test "is renderable" do
    assert {:text, attrs, _} =
             Text.new(1, 1, "Test")
             |> Renderable.to_svg()

    assert [{:x, 1}, {:y, 1}] ==
             attrs
             |> Enum.sort_by(&elem(&1, 0))

  end

  test "is renderable w/o location" do
    assert {:text, attrs, _} =
             Text.new("Test")
             |> Renderable.to_svg()

    assert [{:x, 0}, {:y, 0}] ==
             attrs
             |> Enum.sort_by(&elem(&1, 0))

  end
end
