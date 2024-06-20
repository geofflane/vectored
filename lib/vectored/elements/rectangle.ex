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

  use Vectored.Elements.Element,
    attributes: [x: 0, y: 0, width: nil, height: nil, rx: nil, ry: nil, path_length: nil]

  @type t :: %__MODULE__{
    x: String.t() | number(),
    y: String.t() | number(),
    width: String.t() | number(),
    height: String.t() | number(),
    rx: String.t() | number(),
    ry: String.t() | number(),
    path_length: String.t(),
  }

  @doc """
  Set the x and y properties of the Rectangle to set its location
  """
  @spec at_location(t(), String.t() | number(),  String.t() | number()) :: t()
  def at_location(rectangle, x, y) do
    %{rectangle | x: x, y: y}
  end

  def with_size(rectangle, width, height) do
    %{rectangle | width: width, height: height}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Rectangle{} = element) do
      attrs = Vectored.Elements.Rectangle.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:rectangle, attrs, children}
    end
  end
end
