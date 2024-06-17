defmodule VectoredTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.{Circle, Defs, Group, Text, Svg, Use}

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
      |> Vectored.to_svg_string()

    assert "<svg width=\"100\" y=\"0\" x=\"0\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><g><circle r=\"5\" cx=\"1\" cy=\"1\"/><text y=\"1\" x=\"1\">test</text></g></svg>" == svg
  end

  test "can render xml with defs" do
    assert {:ok, svg} =
      %Svg{
        height: 100,
        width: 100,
        children: [
          %Defs{
            children: [
              %Circle{id: "circle", r: 5},
            ]
          },
          %Use{x: 10, y: 10, href: "#circle"},
          %Use{x: 20, y: 10, href: "#circle"},
          %Use{x: 30, y: 10, href: "#circle"},
        ]}
      |> Vectored.to_svg_string()

    assert "<svg width=\"100\" y=\"0\" x=\"0\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><defs><circle id=\"circle\" r=\"5\" cx=\"0\" cy=\"0\"/></defs><use y=\"10\" x=\"10\" href=\"#circle\"/><use y=\"10\" x=\"20\" href=\"#circle\"/><use y=\"10\" x=\"30\" href=\"#circle\"/></svg>" == svg
  end
end
