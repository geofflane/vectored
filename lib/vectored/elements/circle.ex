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

  @type t :: %__MODULE__{
          cx: String.t() | number() | nil,
          cy: String.t() | number() | nil,
          r: String.t() | number(),
          path_length: number() | nil
        }

  @doc """
  Create a new instance
  """
  @spec new(String.t() | number()) :: t()
  def new(r) do
    %__MODULE__{r: r}
  end

  @spec new(String.t() | number(), String.t() | number(), String.t() | number()) :: t()
  def new(x, y, r) do
    %__MODULE__{cx: x, cy: y, r: r}
  end

  @doc """
  Set the x and y properties of the Circle to set its location
  """
  @spec at_location(t(), number(), number()) :: t()
  def at_location(circle, x, y) do
    %{circle | cx: x, cy: y}
  end

  def with_radius(circle, r) do
    %{circle | radius: r}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Circle{} = element) do
      attrs = Vectored.Elements.Circle.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:circle, attrs, children}
    end
  end
end
