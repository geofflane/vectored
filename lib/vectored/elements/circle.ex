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

  def new(r) do
    %__MODULE__{r: r}
  end
  def new(x, y, r) do
    %__MODULE__{cx: x, cy: y, r: r}
  end

  def at_location(circle, x, y) do
    %{circle | cx: x, cy: y}
  end

  def with_radius(circle, r) do
    %{circle | radius: r}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Circle{} = element) do
      attrs = Vectored.Elements.Circle.attributes(element)
      {:circle, attrs, []}
    end
  end
end
