defmodule Vectored do
  @moduledoc """
  Documentation for `Vectored`.
  """

  alias Vectored.Elements.Svg

  def new() do
    Svg.new()
  end

  def new(width, height) do
    Svg.new(width, height)
  end

  @doc """
  Render an SVG string
  """
  def to_svg(element) do
    Vectored.Renderable.to_svg(element)
  end

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
