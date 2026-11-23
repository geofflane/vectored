defmodule Vectored.Elements.ImageTest do
  use ExUnit.Case, async: true
  alias Vectored.Elements.Image

  doctest Vectored.Elements.Image

  test "is renderable" do
    assert {:image, attrs, []} =
             Vectored.Renderable.to_svg(Image.new(0, 0, 100, 100, "test.png"))

    assert attrs == [height: 100, href: "test.png", width: 100, x: 0, y: 0]
  end

  test "with setters" do
    image =
      Image.new("test.png")
      |> Image.at_location(10, 20)
      |> Image.with_size(50, 60)

    assert image.href == "test.png"
    assert image.x == 10
    assert image.y == 20
    assert image.width == 50
    assert image.height == 60
  end

  test "with_size/3 accepts <length-percentage> strings" do
    image =
      Image.new("test.png")
      |> Image.at_location("10%", "2em")
      |> Image.with_size("100%", "auto")

    assert {:image, attrs, []} = Vectored.Renderable.to_svg(image)
    assert attrs == [height: "auto", href: "test.png", width: "100%", x: "10%", y: "2em"]
  end
end
