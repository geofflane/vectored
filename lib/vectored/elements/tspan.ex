defmodule Vectored.Elements.Tspan do
  @moduledoc """
  The `<tspan>` element defines a subtext within a `<text>` element.

  ## Why use Tspan?
  SVG text doesn't support automatic line breaks or multiple styles within a 
  single string. `<tspan>` is the solution for:

    * **Mixed Styling**: Making one word **bold** or <span style="color:red">red</span>
      within a sentence.
    * **Manual Positioning**: Shifting a specific part of the text using `dx` or `dy`.
    * **Super/Subscripts**: Adjusting the `baseline_shift` of a few characters.

  ## Examples

      # Styling part of a sentence
      Vectored.Elements.Text.new(10, 10, "Price: ")
      |> Vectored.Elements.Text.append(
           Vectored.Elements.Tspan.new("$10.00") 
           |> Vectored.Elements.Tspan.with_font_weight("bold")
           |> Vectored.Elements.Tspan.with_fill("green")
         )

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
  Create a new `<tspan>` with content.

  Position and styling will inherit from the parent `<text>` element unless
  overridden on this tspan.
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
