defmodule Vectored.Elements.Ellipse do
  @moduledoc """
  cx
  The x-axis coordinate of the center of the ellipse. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  cy
  The y-axis coordinate of the center of the ellipse. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  rx
  The x-axis radius of the ellipse. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  ry
  The y-axis radius of the ellipse. Value type: auto|<length>|<percentage> ; Default value: auto; Animatable: yes

  path_length
  The total length of the ellipse's perimeter, in user units. Value type: <number> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [cx: 0, cy: 0, rx: 0, ry: 0, path_length: nil]

  @type t :: %__MODULE__{
          cx: String.t() | number() | nil,
          cy: String.t() | number() | nil,
          rx: String.t() | number(),
          ry: String.t() | number(),
          path_length: number() | nil
        }

  @doc """
  Create a new instance with rx and ry
  """
  @spec new(String.t() | number(), String.t() | number()) :: t()
  def new(rx, ry) do
    %__MODULE__{rx: rx, ry: ry}
  end

  @doc """
  Create a new instance with cx, cy, rx, and ry
  """
  @spec new(
          String.t() | number(),
          String.t() | number(),
          String.t() | number(),
          String.t() | number()
        ) :: t()
  def new(cx, cy, rx, ry) do
    %__MODULE__{cx: cx, cy: cy, rx: rx, ry: ry}
  end

  @doc """
  Set the cx and cy properties of the Ellipse to set its location
  """
  @spec at_location(t(), number(), number()) :: t()
  def at_location(ellipse, x, y) do
    %{ellipse | cx: x, cy: y}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Ellipse{} = element) do
      attrs = Vectored.Elements.Ellipse.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:ellipse, attrs, children}
    end
  end
end
