defmodule Vectored.Elements.TspanTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Text, Tspan}

  test "is renderable" do
    assert {:tspan, attrs, [_text_node]} =
             Vectored.Renderable.to_svg(Tspan.new("hello"))

    assert attrs == []
    # Check if it's an xmlText record (difficult to assert directly without record definition)
    # But we can check if it renders correctly in a full SVG
  end

  test "within text element" do
    text =
      Text.new(10, 10, "Base")
      |> Text.append(Tspan.new("Span") |> Tspan.with_fill("red"))

    {:text, _, children} = Vectored.Renderable.to_svg(text)

    # Expected children: [xmlText("Base"), {:tspan, [fill: "red"], [xmlText("Span")]}]
    assert Enum.any?(children, fn
             {:tspan, attrs, _} -> {:fill, "red"} in attrs
             _ -> false
           end)
  end
end
