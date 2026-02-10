defmodule Vectored.Elements.Pattern do
  @moduledoc """
  The `<pattern>` element defines a graphic that can be repeated (tiled) to 
  fill an area.

  ## Why use a Pattern?
  Patterns allow you to create complex fills like **dots, stripes, or textures**
  without drawing every individual shape manually.

    * **Tiling**: You define a small tile (e.g., a 10x10 square with a circle 
      in it) and SVG will repeat it infinitely to fill a shape of any size.
    * **Efficiency**: Just like gradients, patterns are defined once in 
      `<defs>` and then referenced by `fill="url(#my-pattern)"`.

  ## Attributes

    * `width`, `height` - The size of the repeating tile.
    * `pattern_units` - Defines how the `width` and `height` are calculated 
      (`"userSpaceOnUse"` or `"objectBoundingBox"`).
    * `view_box` - Can be used to make the content of the pattern responsive 
      within its tile.

  ## Examples

      # A simple 10x10 dot pattern
      dot = Vectored.Elements.Circle.new(5, 5, 2)
      pattern = Vectored.Elements.Pattern.new([dot])
      |> Vectored.Elements.Pattern.with_id("dots")
      |> Vectored.Elements.Pattern.with_size(10, 10)
      |> Vectored.Elements.Pattern.with_pattern_units("userSpaceOnUse")

      # Use it to fill a rectangle
      Vectored.Elements.Rectangle.new(0, 0, 100, 100)
      |> Vectored.Elements.Rectangle.with_fill("url(#dots)")

  """

  use Vectored.Elements.Element,
    attributes: [
      x: nil,
      y: nil,
      width: nil,
      height: nil,
      pattern_units: nil,
      pattern_content_units: nil,
      pattern_transform: nil,
      view_box: nil,
      preserve_aspect_ratio: nil,
      href: nil,
      children: []
    ],
    attribute_overrides: [
      pattern_units: :patternUnits,
      pattern_content_units: :patternContentUnits,
      pattern_transform: :patternTransform
    ]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          pattern_units: String.t() | nil,
          pattern_content_units: String.t() | nil,
          pattern_transform: String.t() | nil,
          view_box: String.t() | nil,
          preserve_aspect_ratio: String.t() | nil,
          href: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new pattern with an optional list of children.
  """
  @spec new(list(Vectored.Renderable.t())) :: t()
  def new(children \\ []) do
    %__MODULE__{children: children}
  end

  @doc """
  Set the dimensions of the repeating tile.
  """
  def with_size(pattern, width, height) do
    %{pattern | width: width, height: height}
  end

  @doc """
  Append a child element to the pattern tile.
  """
  def append(%__MODULE__{children: children} = pattern, child) do
    %{pattern | children: children ++ List.wrap(child)}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Pattern{children: children} = element) do
      attrs = Vectored.Elements.Pattern.attributes(element)
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:pattern, attrs, child_elems ++ common_children}
    end
  end
end
