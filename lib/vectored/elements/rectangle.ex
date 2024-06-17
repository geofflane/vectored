defmodule Vectored.Elements.Rectangle do
  @moduledoc """
  x
  The x coordinate of the rect. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  y
  The y coordinate of the rect. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  width
  The width of the rect. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  height
  The height of the rect. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  rx
  The horizontal corner radius of the rect. Defaults to ry if it is specified. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  ry
  The vertical corner radius of the rect. Defaults to rx if it is specified. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  path_length
  The total length of the rectangle's perimeter, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element, x: 0, y: 0, width: nil, height: nil, rx: nil, ry: nil, path_length: nil

  def rendered_key(:path_length), do: :pathLength
  def rendered_key(k), do: k

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Rectangle{} = element) do
      attrs = Vectored.Elements.Rectangle.attributes(element)
      {:rectangle, attrs, []}
    end
  end
end
