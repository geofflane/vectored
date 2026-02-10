defmodule Vectored.Elements.Desc do
  @moduledoc """
  The `<desc>` element provides a detailed text description of an element.

  ## Why use Desc?
  While `<title>` is for short names, `<desc>` is for **complex descriptions**.

    * **Accessibility**: It provides a way to explain complex graphics (like
      charts or diagrams) to screen reader users.
    * **Documentation**: It helps keep your SVG source code self-documenting.

  The `Vectored.Elements.Element.with_description/2` helper is the recommended
  way to add a description to any shape.

  ## Examples

      Vectored.Elements.Group.new([chart_bars])
      |> Vectored.Elements.Group.with_description("A bar chart showing quarterly revenue growth.")

  """

  # desc doesn't have any attributes and we want to reference it in Element, so
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

    def to_svg(%Vectored.Elements.Desc{content: content}) do
      text = xmlText(value: content)
      {:desc, [], [text]}
    end
  end
end
