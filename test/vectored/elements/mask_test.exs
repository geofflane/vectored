defmodule Vectored.Elements.MaskTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Mask, Circle}

  test "is renderable" do
    mask =
      Mask.new([Circle.new(50) |> Circle.with_fill("white")])
      |> Mask.with_id("my-mask")

    assert {:mask, attrs, children} = Vectored.Renderable.to_svg(mask)
    assert {:id, "my-mask"} in attrs
    assert length(children) == 1
  end
end
