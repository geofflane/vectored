defmodule Vectored.Elements.SymbolTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Symbol, Circle}

  test "is renderable" do
    symbol =
      Symbol.new([Circle.new(10)])
      |> Symbol.with_view_box(0, 0, 100, 100)
      |> Symbol.with_id("my-symbol")

    assert {:symbol, attrs, children} = Vectored.Renderable.to_svg(symbol)

    assert {:id, "my-symbol"} in attrs
    assert {:viewBox, "0 0 100 100"} in attrs
    assert length(children) == 1
  end
end
