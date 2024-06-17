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

  use Vectored.Elements.Element, x: 0, y: 0, dx: nil, dy: nil, rotate: nil, length_adjust: nil, text_length: nil, content: nil

  def rendered_key(:length_adjust), do: :lengthAdjust
  def rendered_key(:text_length), do: :textLength
  def rendered_key(k), do: k

  defimpl Vectored.Renderable do
    require Record
    Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

    def to_svg(%Vectored.Elements.Text{content: content} = element) do
      attrs = Vectored.Elements.Text.attributes(element)
      text = xmlText(value: content)
      {:text, attrs, [text]}
    end
  end
end
