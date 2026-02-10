defmodule Vectored.Elements.RadialGradient do
  @moduledoc """
  The `<radialGradient>` element defines a transition between colors that 
  radiates from a central point.

  ## Why use a Radial Gradient?
  Radial gradients are perfect for creating **depth, lighting, and 3D effects**.

    * **Spheres and Orbs**: Make a flat circle look like a 3D ball by adding 
      a radial gradient with a highlight.
    * **Glow Effects**: Create a soft glow or a "sun" effect by radiating 
      from a bright color to transparent.
    * **Vignettes**: Create a subtle darkening around the edges of a 
      rectangular shape.

  ## Attributes

    * `cx`, `cy`, `r` - The center and radius of the outermost circle of the 
      gradient.
    * `fx`, `fy` - The "focal point". Moving this away from `cx, cy` allows 
      you to shift the "highlight" of the gradient, making it look like 
      it's lit from one side.

  ## Examples

      # A simple sun-like gradient
      Vectored.Elements.RadialGradient.new([
        Vectored.Elements.Stop.new(0, "yellow"),
        Vectored.Elements.Stop.new(1, "orange")
      ])
      |> Vectored.Elements.RadialGradient.with_center(50, 50, 50)
      |> Vectored.Elements.RadialGradient.with_id("sun-grad")

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
  Create a new radial gradient with an optional list of `<stop>` children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Set the center and radius of the gradient.
  """
  @spec with_center(t(), number(), number(), number()) :: t()
  def with_center(gradient, cx, cy, r) do
    %{gradient | cx: cx, cy: cy, r: r}
  end

  @doc """
  Set the focal point of the gradient.

  The focal point is where the first color (stop at offset 0) starts. Shifting
  this creates a "light source" effect.
  """
  @spec with_focal_point(t(), number(), number(), number() | nil) :: t()
  def with_focal_point(gradient, fx, fy, fr \\ nil) do
    %{gradient | fx: fx, fy: fy, fr: fr}
  end

  @doc """
  Append one or more children (typically `<stop>` elements) to the gradient.
  """
  @spec append(t(), Vectored.Renderable.t() | list(Vectored.Renderable.t())) :: t()
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
