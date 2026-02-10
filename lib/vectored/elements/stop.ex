defmodule Vectored.Elements.Stop do
  @moduledoc """
  The <stop> SVG element defines a color and its opacity to use at a fixed offset of a gradient.
  """

  use Vectored.Elements.Element,
    attributes: [
      offset: nil,
      stop_color: nil,
      stop_opacity: nil
    ]

  @type t :: %__MODULE__{
          offset: String.t() | number() | nil,
          stop_color: String.t() | nil,
          stop_opacity: String.t() | number() | nil
        }

  @doc """
  Create a new stop
  """
  @spec new(String.t() | number(), String.t() | nil) :: t()
  def new(offset, color \\ nil) do
    %__MODULE__{offset: offset, stop_color: color}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Stop{} = element) do
      attrs = Vectored.Elements.Stop.attributes(element)
      children = Vectored.Elements.Element.render_common_children(element)
      {:stop, attrs, children}
    end
  end
end
