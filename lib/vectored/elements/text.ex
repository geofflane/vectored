defmodule Vectored.Elements.Text do
  @moduledoc """
  x
  The x coordinate of the starting point of the text baseline. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  y
  The y coordinate of the starting point of the text baseline. Value type: <length>|<percentage> ; Default value: 0; Animatable: yes

  dx
  Shifts the text position horizontally from a previous text element. Value type: <length>|<percentage> ; Default value: none; Animatable: yes

  dy
  Shifts the text position vertically from a previous text element. Value type: <length>|<percentage> ; Default value: none; Animatable: yes

  rotate
  Rotates orientation of each individual glyph. Can rotate glyphs individually. Value type: <list-of-number> ; Default value: none; Animatable: yes

  length_adjust
  How the text is stretched or compressed to fit the width defined by the textLength attribute. Value type: spacing|spacingAndGlyphs; Default value: spacing; Animatable: yes

  text_length
  A width that the text should be scaled to fit. Value type: <length>|<percentage> ; Default value: none; Animatable: yes
  """

  use Vectored.Elements.Element,
    attributes: [
      x: 0,
      y: 0,
      dx: nil,
      dy: nil,
      rotate: nil,
      length_adjust: nil,
      text_length: nil,
      content: nil,
      font_size: nil
    ],
    attribute_overrides: [length_adjust: :lengthAdjust, text_length: :textLength]

  @type t :: %__MODULE__{
          x: String.t() | number(),
          y: String.t() | number(),
          dx: String.t() | number() | nil,
          dy: String.t() | number() | nil,
          rotate: String.t() | nil,
          length_adjust: String.t() | nil,
          text_length: String.t() | number() | nil,
          content: String.t()
        }

  @spec new(String.t() | number(), String.t() | number(), String.t()) :: t()
  def new(x, y, content) do
    %__MODULE__{x: x, y: y, content: content}
  end

  @spec new(String.t()) :: t()
  def new(content) do
    %__MODULE__{content: content}
  end

  @doc """
  Set the x and y properties of the Circle to set its location
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(text, x, y) do
    %{text | x: x, y: y}
  end

  defimpl Vectored.Renderable do
    require Record
    Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

    def to_svg(%Vectored.Elements.Text{content: content} = element) do
      attrs = Vectored.Elements.Text.attributes(element)
      text = xmlText(value: content)
      children = Vectored.Elements.Element.render_common_children(element)
      {:text, attrs, [text | children]}
    end
  end
end
