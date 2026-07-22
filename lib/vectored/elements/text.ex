defmodule Vectored.Elements.Text do
  @moduledoc """
  The `<text>` element renders a graphics element consisting of text.

  ## Attributes

    * `x`, `y` - Position of the text. By default, `y` is the **baseline**
      of the text, meaning the bottom of most letters (but not descenders
      like 'y' or 'g').
    * `text_anchor` - How the text aligns to the `x` coordinate. `"start"`
      (left-aligned), `"middle"` (centered), or `"end"` (right-aligned).
    * `dominant_baseline` - How the text aligns vertically. Use `"middle"`
      or `"central"` to center text on the `y` coordinate.

  `x`, `y`, `dx`, `dy` and `text_length` accept a number for user units, or a
  string for a percentage or CSS unit (`"50%"`, `"2em"`, `"10px"`).

  `x`, `y`, `dx`, `dy` and `rotate` are additionally *lists* — a
  space-separated string applies one value per glyph, so `x: "10 20 30"`
  positions the first three characters individually and `rotate: "0 15 30"`
  fans them out. A single value applies to the whole run.

  ## Why use SVG Text?
  SVG text is selectable and searchable by browsers, and it scales perfectly
  with your graphics. Unlike canvas-based text, it remains crisp at any zoom
  level and is accessible to screen readers.

  ## Examples

      # Centered text in the middle of a coordinate system
      iex> Vectored.Elements.Text.new(50, 50, "Centered")
      ...> |> Vectored.Elements.Text.with_text_anchor("middle")
      ...> |> Vectored.Elements.Text.with_dominant_baseline("middle")
      ...> |> Vectored.to_svg_string()
      {:ok, ~s|<text dominant-baseline="middle" text-anchor="middle" x="50" y="50">Centered</text>|}

      # Per-glyph positioning: each character gets its own x and rotation
      iex> Vectored.Elements.Text.new("10 20 30", "40", "abc")
      ...> |> Vectored.Elements.Text.with_rotate("0 15 30")
      ...> |> Vectored.to_svg_string()
      {:ok, ~s|<text rotate="0 15 30" x="10 20 30" y="40">abc</text>|}

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
      font_size: nil,
      children: []
    ],
    attribute_overrides: [length_adjust: :lengthAdjust, text_length: :textLength]

  @type t :: %__MODULE__{
          x: String.t() | number(),
          y: String.t() | number(),
          dx: String.t() | number() | nil,
          dy: String.t() | number() | nil,
          rotate: String.t() | number() | nil,
          length_adjust: String.t() | nil,
          text_length: String.t() | number() | nil,
          content: String.t() | nil,
          children: list(Vectored.Renderable.t())
        }

  @doc """
  Create a new text element at a specific location.

  ## Parameters

    * `x` - The x-coordinate of the baseline start.
    * `y` - The y-coordinate of the baseline start.
    * `content` - The string to display.
  """
  @spec new(String.t() | number(), String.t() | number(), String.t()) :: t()
  def new(x, y, content) do
    %__MODULE__{x: x, y: y, content: content}
  end

  @doc """
  Create a new text element with content. Position defaults to (0,0).
  """
  @spec new(String.t()) :: t()
  def new(content) do
    %__MODULE__{content: content}
  end

  @doc """
  Set the location of the text element.
  """
  @spec at_location(t(), String.t() | number(), String.t() | number()) :: t()
  def at_location(text, x, y) do
    %{text | x: x, y: y}
  end

  @doc """
  Append a child element, such as a `<tspan>`.
  """
  @spec append(t(), Vectored.Renderable.t()) :: t()
  def append(%__MODULE__{children: children} = text, child) do
    %{text | children: children ++ [child]}
  end

  defimpl Vectored.Renderable do
    require Record
    Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

    def to_svg(%Vectored.Elements.Text{content: content, children: text_children} = element) do
      attrs = Vectored.Elements.Text.attributes(element)

      text_node = if content, do: [xmlText(value: content)], else: []
      rendered_children = Enum.map(text_children, &Vectored.Renderable.to_svg/1)
      common_children = Vectored.Elements.Element.render_common_children(element)

      {:text, attrs, text_node ++ rendered_children ++ common_children}
    end
  end
end
