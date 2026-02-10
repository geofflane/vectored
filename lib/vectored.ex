defmodule Vectored do
  @moduledoc """
  Vectored is a library for creating and rendering SVG documents using a functional API.

  It provides a structured way to build SVG elements and render them to XML strings.
  The library follows the SVG specification and provides helper functions for common
  attributes and transformations.

  ## Examples

      iex> Vectored.new(100, 100)
      ...> |> Vectored.Elements.Svg.add_child(Vectored.Elements.Circle.new(50, 50, 40))
      ...> |> Vectored.to_svg_string()
      {:ok, "<svg height=\"100\" width=\"100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"40\"/></svg>"}

  """

  alias Vectored.Elements.Svg

  @doc """
  Create a new SVG document with default dimensions.

  Returns a `%Vectored.Elements.Svg{}` struct.
  """
  def new() do
    Svg.new()
  end

  @doc """
  Create a new SVG document with specified width and height.

  ## Parameters

    * `width` - The width of the SVG viewport.
    * `height` - The height of the SVG viewport.

  Returns a `%Vectored.Elements.Svg{}` struct.
  """
  def new(width, height) do
    Svg.new(width, height)
  end

  @doc """
  Render a Vectored element to its internal representation.

  This is generally used internally by `to_svg_string/1` but can be useful
  for inspecting the structure before final rendering.
  """
  def to_svg(element) do
    Vectored.Renderable.to_svg(element)
  end

  @doc """
  Render a Vectored element or document to an XML string.

  It automatically adds the `xmlns` attribute if the root element is an SVG tag.

  ## Examples

      iex> Vectored.Elements.Circle.new(10) |> Vectored.to_svg_string()
      {:ok, "<circle r=\"10\"/>"}

  """
  def to_svg_string(element) do
    doc =
      case to_svg(element) do
        {:svg, attrs, elems} ->
          {:svg, attrs ++ [xmlns: "http://www.w3.org/2000/svg"], elems}

        element ->
          element
      end

    xml_str =
      [doc]
      |> :xmerl.export_simple(:xmerl_xml, [{:prolog, ""}])
      |> :lists.flatten()
      |> to_string()

    {:ok, xml_str}
  end
end
