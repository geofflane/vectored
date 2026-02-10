defmodule Vectored.Elements.Image do
  @moduledoc """
  The <image> SVG element includes images inside SVG documents.
  It can display raster image files or other SVG files.
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
  Create a new image with href
  """
  @spec new(String.t()) :: t()
  def new(href) do
    %__MODULE__{href: href}
  end

  @doc """
  Create a new image with coordinates, size and href
  """
  @spec new(number(), number(), number(), number(), String.t()) :: t()
  def new(x, y, width, height, href) do
    %__MODULE__{x: x, y: y, width: width, height: height, href: href}
  end

  @doc """
  Set the x and y properties
  """
  @spec at_location(t(), number(), number()) :: t()
  def at_location(image, x, y) do
    %{image | x: x, y: y}
  end

  @doc """
  Set the width and height
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
