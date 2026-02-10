defmodule Vectored.Elements.StopTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Stop

  test "is renderable" do
    stop =
      Stop.new("50%", "red")
      |> Stop.with_stop_opacity(0.5)

    assert {:stop, attrs, []} = Vectored.Renderable.to_svg(stop)
    assert {:offset, "50%"} in attrs
    assert {:"stop-color", "red"} in attrs
    assert {:"stop-opacity", "0.5"} in attrs
  end
end
