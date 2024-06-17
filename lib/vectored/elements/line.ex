defmodule Vectored.Elements.Line do
  @moduledoc """
  x1
  Defines the x-axis coordinate of the line starting point. Value type: <length>|<percentage>|<number> ; Default value: 0; Animatable: yes

  x2
  Defines the x-axis coordinate of the line ending point. Value type: <length>|<percentage>|<number> ; Default value: 0; Animatable: yes

  y1
  Defines the y-axis coordinate of the line starting point. Value type: <length>|<percentage>|<number> ; Default value: 0; Animatable: yes

  y2
  Defines the y-axis coordinate of the line ending point. Value type: <length>|<percentage>|<number> ; Default value: 0; Animatable: yes

  path_length
  Defines the total path length in user units. Value type: <number> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element, x1: 0, x2: 0, y1: 0, y2: 0, path_length: nil

  def rendered_key(:path_length), do: :pathLength
  def rendered_key(k), do: k

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Line{} = element) do
      attrs = Vectored.Elements.Line.attributes(element)
      {:line, attrs, []}
    end
  end
end
