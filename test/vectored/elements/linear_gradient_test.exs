defmodule Vectored.Elements.LinearGradientTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{LinearGradient, Stop}

  test "is renderable" do
    gradient =
      LinearGradient.new([
        Stop.new(0, "white"),
        Stop.new(1, "black")
      ])
      |> LinearGradient.with_id("my-gradient")
      |> LinearGradient.with_coordinates(0, 0, 1, 1)

    assert {:linearGradient, attrs, children} = Vectored.Renderable.to_svg(gradient)
    assert {:id, "my-gradient"} in attrs
    assert {:x1, 0} in attrs
    assert {:y2, 1} in attrs
    assert length(children) == 2
  end
end
