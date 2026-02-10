defmodule Vectored.Elements.Title do
  @moduledoc """
  The `<title>` element provides a short, human-readable name for an element.

  ## Why use Title?
  In SVG, `<title>` is primarily used for **accessibility and tooltips**.

    * **Accessibility**: Screen readers use the `<title>` to describe an
      element to users with visual impairments.
    * **Tooltips**: Most browsers will display the content of a `<title>`
      as a tooltip when the user hovers over the element.

  Place the `<title>` as the first child of the element you want to describe.
  The `Vectored.Elements.Element.with_title/2` helper is the recommended way
  to add a title to any shape.

  ## Examples

      Vectored.Elements.Circle.new(50)
      |> Vectored.Elements.Circle.with_title("A descriptive tooltip")

  """

  # title doesn't have any attributes and we want to reference it in Element, so
  # keep it simple
  defstruct content: nil

  @type t :: %__MODULE__{
          content: String.t() | nil
        }

  @spec new(String.t()) :: t()
  def new(content) do
    %__MODULE__{content: content}
  end

  defimpl Vectored.Renderable do
    require Record
    Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

    def to_svg(%Vectored.Elements.Title{content: content}) do
      text = xmlText(value: content)
      {:title, [], [text]}
    end
  end
end
