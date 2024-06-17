defmodule Vectored.Elements.Use do
  @moduledoc """
  href
  The URL to an element/fragment that needs to be duplicated. See Usage notes for details on common pitfalls.
  Value type: <URL> ; Default value: none; Animatable: yes

  x
  The x coordinate of an additional final offset transformation applied to the <use> element.
  Value type: <coordinate> ; Default value: 0; Animatable: yes

  y
  The y coordinate of an additional final offset transformation applied to the <use> element.
  Value type: <coordinate> ; Default value: 0; Animatable: yes

  width
  The width of the use element.
  Value type: <length> ; Default value: 0; Animatable: yes

  height
  The height of the use element.
  Value type: <length> ; Default value: 0; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [href: nil, x: 0, y: 0, width: nil, height: nil]

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Use{} = element) do
      attrs = Vectored.Elements.Use.attributes(element)
      {:use, attrs, []}
    end
  end
end
