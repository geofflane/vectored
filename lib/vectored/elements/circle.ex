defmodule Vectored.Elements.Circle do
  @moduledoc """
  cx
  The x-axis coordinate of the center of the circle. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  cy
  The y-axis coordinate of the center of the circle. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  r
  The radius of the circle. A value lower or equal to zero disables rendering of the circle. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  path_length
  The total length for the circle's circumference, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [cx: 0, cy: 0, r: 0, path_length: nil]

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Circle{} = element) do
      attrs = Vectored.Elements.Circle.attributes(element)
      {:circle, attrs, []}
    end
  end
end
