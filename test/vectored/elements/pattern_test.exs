defmodule Vectored.Elements.PatternTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Pattern, Circle}

  test "is renderable" do
    pattern =
      Pattern.new([Circle.new(5)])
      |> Pattern.with_id("my-pattern")
      |> Pattern.with_size(10, 10)

    assert {:pattern, attrs, children} = Vectored.Renderable.to_svg(pattern)
    assert {:id, "my-pattern"} in attrs
    assert {:width, 10} in attrs
    assert {:height, 10} in attrs
    assert length(children) == 1
  end
end
