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
end
