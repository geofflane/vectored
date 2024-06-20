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

  use Vectored.Elements.Element,
    attributes: [x1: 0, x2: 0, y1: 0, y2: 0, path_length: nil]

  @type t :: %__MODULE__{
    x1: String.t() | number(),
    y1: String.t() | number(),
    x2: String.t() | number(),
    y2: String.t() | number(),
    path_length: number() | nil,
  }

  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end

  def from(line, x, y) do
    %{line | x1: x, y1: y}
  end

  def to(line, x, y) do
    %{line | x2: x, y2: y}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Line{} = element) do
      attrs = Vectored.Elements.Line.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:line, attrs, children}
    end
  end
end
