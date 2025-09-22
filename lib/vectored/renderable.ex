defprotocol Vectored.Renderable do
  @moduledoc """
  Protocol to to export data to an SVG. This protocol uses Erlang's xmerl under
  the covers, so this is responsible for generating valid xmerl structures.
  """

  @type simple_element ::
          {atom(), [{atom(), iolist() | atom() | integer()}], [simple_element()]}
          | {atom(), [simple_element()]}
          | atom()
          | iolist()
          | :xmerl.element()

  @doc """
  Render an element as xmerl XML structures.
  """
  @spec to_svg(t()) :: simple_element() | :xmerl.xmlElement()
  def to_svg(element)
end
