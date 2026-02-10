defmodule Vectored.Elements.RadialGradient do
  @moduledoc """
  The <radialGradient> SVG element lets authors define radial gradients to apply to other SVG elements.
  """

  use Vectored.Elements.Element,
    attributes: [
      cx: nil,
      cy: nil,
      r: nil,
      fx: nil,
      fy: nil,
      fr: nil,
      gradient_units: nil,
      gradient_transform: nil,
      spread_method: nil,
      href: nil,
      children: []
    ],
    attribute_overrides: [
      gradient_units: :gradientUnits,
      gradient_transform: :gradientTransform,
      spread_method: :spreadMethod
    ]

  @type t :: %__MODULE__{
          cx: String.t() | number() | nil,
          cy: String.t() | number() | nil,
          r: String.t() | number() | nil,
          fx: String.t() | number() | nil,
          fy: String.t() | number() | nil,
          fr: String.t() | number() | nil,
          gradient_units: String.t() | nil,
          gradient_transform: String.t() | nil,
          spread_method: String.t() | nil,
          href: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new radialGradient with children (stops)
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Set center and radius
  """
  def with_center(gradient, cx, cy, r) do
    %{gradient | cx: cx, cy: cy, r: r}
  end

  @doc """
  Set focal point
  """
  def with_focal_point(gradient, fx, fy, fr \\ nil) do
    %{gradient | fx: fx, fy: fy, fr: fr}
  end

  @doc """
  Append a stop
  """
  def append(%__MODULE__{children: children} = gradient, stop) do
    %{gradient | children: children ++ List.wrap(stop)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.RadialGradient{children: children} = element) do
      attrs = Vectored.Elements.RadialGradient.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:radialGradient, attrs, child_elems ++ common_children}
    end
  end
end
