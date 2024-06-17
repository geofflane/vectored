defprotocol Vectored.Renderable do
  @moduledoc """
  Protocol to allow the ability to export something to an SVG
  """
  @spec to_svg(any()) :: :xmerl.simple_element() | :xmerl.xmlElement()
  def to_svg(element)
end
