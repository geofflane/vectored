defmodule Vectored.Elements.RadialGradientTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{RadialGradient, Stop}

  test "is renderable" do
    gradient =
      RadialGradient.new([
        Stop.new(0, "white"),
        Stop.new(1, "black")
      ])
      |> RadialGradient.with_id("my-radial")
      |> RadialGradient.with_center(0.5, 0.5, 0.5)

    assert {:radialGradient, attrs, children} = Vectored.Renderable.to_svg(gradient)
    assert {:id, "my-radial"} in attrs
    assert {:cx, "0.5"} in attrs
    assert {:cy, "0.5"} in attrs
    assert {:r, "0.5"} in attrs
    assert length(children) == 2
  end
end
