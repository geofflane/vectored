defmodule Vectored.Elements.Mask do
  @moduledoc """
  The `<mask>` element defines an alpha mask for compositing objects into 
  the background.

  ## Why use a Mask?
  Masks are different from clipping paths. While a `clipPath` is a hard "cookie
  cutter" (visible or not), a mask allows for **transparency and gradients**.

    * **Luminance Masking**: By default, SVG masks use the brightness of the 
      mask's content to determine transparency. White in the mask means the 
      object is fully visible; black means it is fully hidden; grey means it 
      is semi-transparent.
    * **Complex Fading**: Use a `linearGradient` inside a mask to make an 
      image fade away gradually.

  ## Examples

      # Create a mask that fades from white to black
      gradient = Vectored.Elements.LinearGradient.new([
        Vectored.Elements.Stop.new(0, "white"),
        Vectored.Elements.Stop.new(1, "black")
      ]) |> Vectored.Elements.LinearGradient.with_id("fade-grad")

      mask = Vectored.Elements.Mask.new([
        Vectored.Elements.Rectangle.new(0, 0, 100, 100) 
        |> Vectored.Elements.Rectangle.with_fill("url(#fade-grad)")
      ]) |> Vectored.Elements.Mask.with_id("my-mask")

      # Apply the mask to a shape
      Vectored.Elements.Circle.new(50, 50, 40)
      |> Vectored.Elements.Circle.with_mask("url(#my-mask)")

  """

  use Vectored.Elements.Element,
    attributes: [
      x: nil,
      y: nil,
      width: nil,
      height: nil,
      mask_units: nil,
      mask_content_units: nil,
      children: []
    ],
    attribute_overrides: [
      mask_units: :maskUnits,
      mask_content_units: :maskContentUnits
    ]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          mask_units: String.t() | nil,
          mask_content_units: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new mask with an optional list of children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Append a child element to the mask.
  """
  def append(%__MODULE__{children: children} = mask, child) do
    %{mask | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Mask{children: children} = element) do
      attrs = Vectored.Elements.Mask.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:mask, attrs, child_elems ++ common_children}
    end
  end
end
