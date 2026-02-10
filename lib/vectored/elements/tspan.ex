defmodule Vectored.Elements.Tspan do
  @moduledoc """
  The <tspan> SVG element defines a subtext within a <text> element or another <tspan> element.
  It allows for separate styling and positioning of that subtext.
  """

  use Vectored.Elements.Element,
    attributes: [
      x: nil,
      y: nil,
      dx: nil,
      dy: nil,
      rotate: nil,
      length_adjust: nil,
      text_length: nil,
      content: nil
    ],
    attribute_overrides: [length_adjust: :lengthAdjust, text_length: :textLength]

  @type t :: %__MODULE__{
          x: String.t() | number() | nil,
          y: String.t() | number() | nil,
          dx: String.t() | number() | nil,
          dy: String.t() | number() | nil,
          rotate: String.t() | nil,
          length_adjust: String.t() | nil,
          text_length: String.t() | number() | nil,
          content: String.t()
        }

  @doc """
  Create a new tspan with content
  """
  @spec new(String.t()) :: t()
  def new(content) do
    %__MODULE__{content: content}
  end

  defimpl Vectored.Renderable do
    require Record
    Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

    def to_svg(%Vectored.Elements.Tspan{content: content} = element) do
      attrs = Vectored.Elements.Tspan.attributes(element)
      text = xmlText(value: content)
      children = Vectored.Elements.Element.render_common_children(element)
      {:tspan, attrs, [text | children]}
    end
  end
end
