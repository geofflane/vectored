defmodule Vectored.Elements.ClipPathTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{ClipPath, Circle}

  test "is renderable" do
    clip =
      ClipPath.new([Circle.new(50)])
      |> ClipPath.with_id("my-clip")

    assert {:clipPath, attrs, children} = Vectored.Renderable.to_svg(clip)
    assert {:id, "my-clip"} in attrs
    assert length(children) == 1
  end
end
