defmodule VectoredTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Circle, Group, Text, Svg}

  test "can render svg" do
    assert _svg =
      %Svg{
        height: 100,
        width: 100,
        children: [
          %Group{
            children: [
              %Circle{cx: 1, cy: 1, r: 5},
              %Text{x: 1, y: 1, content: "test"}
            ]}
        ]}
      |> Vectored.to_svg()
  end

  test "can render xml" do
    assert {:ok, svg} =
      %Svg{
        height: 100,
        width: 100,
        children: [
          %Group{
            children: [
              %Circle{cx: 1, cy: 1, r: 5},
              %Text{x: 1, y: 1, content: "test"}
            ]}
        ]}
      |> Vectored.to_xml_string()

    assert "<svg width=\"100\" y=\"0\" x=\"0\" height=\"100\"><g><circle r=\"5\" cx=\"1\" cy=\"1\"/><text y=\"1\" x=\"1\">test</text></g></svg>" == svg
  end
end
