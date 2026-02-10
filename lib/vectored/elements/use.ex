defmodule Vectored.Elements.Use do
  @moduledoc """
  The `<use>` element duplicates a graphical object defined elsewhere in the SVG.

  ## Why use Use?
  The `<use>` element is the "copy-paste" of the SVG world. It allows you to:

    * **Save space**: Define a complex icon once in `<defs>` and "use" it
      multiple times.
    * **Centralized updates**: Change the original definition, and every
      duplicate updates instantly.
    * **Performance**: The browser only has to process the geometry once.

  ## Examples

      # Define a star once
      defs = Vectored.Elements.Defs.new([
        Vectored.Elements.Circle.new(0, 0, 5) |> Vectored.Elements.Circle.with_id("star")
      ])

      # Place many stars in different spots
      stars = [
        Vectored.Elements.Use.new("#star") |> Vectored.Elements.Use.at_location(10, 10),
        Vectored.Elements.Use.new("#star") |> Vectored.Elements.Use.at_location(50, 20)
      ]

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

  @doc """
  Create a new `<use>` element referencing an ID via `href`.
  """
  @spec new(String.t()) :: t()
  def new(href) do
    %__MODULE__{href: href}
  end

  @doc """
  Create a new `<use>` element with `href` and position.
  """
  @spec new(String.t(), String.t() | number(), String.t() | number()) :: t()
  def new(href, x, y) do
    %__MODULE__{href: href, x: x, y: y}
  end

  @doc """
  Set the location of the `<use>` element.
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(use, x, y) do
    %{use | x: x, y: y}
  end

  @doc """
  Set the dimensions of the `<use>` element.
  """
  @spec with_size(t(), String.t() | number(), String.t() | number()) :: t()
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
