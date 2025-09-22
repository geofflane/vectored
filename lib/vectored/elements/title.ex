defmodule Vectored.Elements.Title do
  @moduledoc """
  SVG title element
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
