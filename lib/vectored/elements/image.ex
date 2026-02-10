defmodule Vectored.Elements.Image do
  @moduledoc """
  The `<image>` element allows including external images (raster or SVG) inside
  an SVG document.

  ## Attributes

    * `x`, `y` - The coordinates of the top-left corner of the image.
    * `width`, `height` - The dimensions of the image.
    * `href` - The URL or path to the image file.

  ## Examples

      iex> Vectored.Elements.Image.new("https://example.com/logo.png")
      ...> |> Vectored.Elements.Image.at_location(10, 10)
      ...> |> Vectored.Elements.Image.with_size(100, 100)

  """

  use Vectored.Elements.Element,
    attributes: [x: 0, y: 0, width: nil, height: nil, href: nil]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil,
          href: String.t() | nil
        }

  @doc """
  Create a new image with the specified href.
  """
  @spec new(String.t()) :: t()
  def new(href) do
    %__MODULE__{href: href}
  end

  @doc """
  Create a new image with position, dimensions, and href.
  """
  @spec new(number(), number(), number(), number(), String.t()) :: t()
  def new(x, y, width, height, href) do
    %__MODULE__{x: x, y: y, width: width, height: height, href: href}
  end

  @doc """
  Set the location of the image.
  """
  @spec at_location(t(), number(), number()) :: t()
  def at_location(image, x, y) do
    %{image | x: x, y: y}
  end

  @doc """
  Set the dimensions of the image.
  """
  @spec with_size(t(), number(), number()) :: t()
  def with_size(image, width, height) do
    %{image | width: width, height: height}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Image{} = element) do
      attrs = Vectored.Elements.Image.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:image, attrs, children}
    end
  end
end
