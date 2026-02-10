defprotocol Vectored.Renderable do
  @moduledoc """
  Protocol for rendering data structures to SVG internal representations.

  This protocol is responsible for converting Vectored element structs into
  the format expected by Erlang's `:xmerl`.

  Most users will interact with `Vectored.to_svg_string/1` instead of calling
  this protocol directly.

  ## Format

  The rendered format is typically a tuple: `{tag_name, attributes, children}`.
  - `tag_name` is an atom (e.g., `:circle`).
  - `attributes` is a keyword list of `{atom, value}` pairs.
  - `children` is a list of rendered elements or text nodes.

  """

  @type simple_element ::
          {atom(), [{atom(), iolist() | atom() | integer()}], [simple_element()]}
          | {atom(), [simple_element()]}
          | atom()
          | iolist()
          | :xmerl.element()

  @doc """
  Render an element as xmerl-compatible XML structures.
  """
  @spec to_svg(t()) :: simple_element() | :xmerl.xmlElement()
  def to_svg(element)
end
