defmodule Vectored.Elements.Stop do
  @moduledoc """
  The `<stop>` element defines a color and its opacity at a fixed offset
  along a gradient.

  ## Attributes

    * `offset` - Position along the gradient vector (number between 0 and 1, or percentage like `"50%"`).
    * `stop_color` - The color at this offset.
    * `stop_opacity` - Opacity of the color (number between 0 and 1).

  ## Examples

      iex> Vectored.Elements.Stop.new(0, "red")
      iex> Vectored.Elements.Stop.new("100%", "#0000ff")
      ...> |> Vectored.Elements.Stop.with_stop_opacity(0.5)

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
  Create a new gradient stop.

  ## Parameters

    * `offset` - Position (0.0 to 1.0 or percentage string).
    * `color` - Color value (optional).
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
