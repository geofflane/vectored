defmodule Vectored do
  @moduledoc """
  Documentation for `Vectored`.
  """

  @doc """
  Render an SVG string
  """
  def to_svg(element) do
    Vectored.Renderable.to_svg(element)
  end

  def to_xml_string(element) do
    doc = to_svg(element)

    xml_str =
      [doc]
      |> :xmerl.export_simple(:xmerl_xml, [{:prolog, ""}])
      |> :lists.flatten()
      |> to_string()

    {:ok, xml_str}
  end
end
