defmodule Vectored.Elements.Use do
  @moduledoc """
  The <use> element takes nodes from within the SVG document, and duplicates them somewhere else.
  """

  use Vectored.Elements.Element,
    attributes: []

  @type t :: %__MODULE__{
          href: String.t(),
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          width: String.t() | number() | nil,
          height: String.t() | number() | nil
        }

  @spec new(String.t()) :: t()
  def new(href) do
    %__MODULE__{href: href}
  end

  @spec new(String.t(), String.t() | number(), String.t() | number()) :: t()
  def new(href, x, y) do
    %__MODULE__{href: href, x: x, y: y}
  end

  @doc """
  Set the x and y properties of the Use to set its location
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(use, x, y) do
    %{use | x: x, y: y}
  end

  def with_size(use, width, height) do
    %{use | width: width, height: height}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Use{} = element) do
      attrs = Vectored.Elements.Use.attributes(element)
      common_children = Vectored.Elements.Element.render_common_children(element)
      {:use, attrs, common_children}
    end
  end
end
