defmodule Vectored.Elements.ElementTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Circle

  test "common attributes are available" do
    circle = Circle.new(5)
    circle = Circle.with_href(circle, "http://example.com")
    assert circle.href == "http://example.com"

    {:circle, attrs, _} = Vectored.Renderable.to_svg(circle)
    assert {:href, "http://example.com"} in attrs
  end

  test "title renders before desc" do
    assert {:circle, _attrs, [{:title, [], _}, {:desc, [], _}]} =
             Circle.new(5)
             |> Circle.with_description("a description")
             |> Circle.with_title("a title")
             |> Vectored.Renderable.to_svg()
  end
end
