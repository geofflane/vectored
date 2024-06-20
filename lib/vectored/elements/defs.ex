defmodule Vectored.Elements.Defs do
  @moduledoc """
  SVG defs allow you to define elements and reference them one or more times in
  an SVG.
  """

  defstruct [children: []]

  @type children() :: list(Vectored.Renderable.t())
  @type t :: %__MODULE__{
    children: children()
  }

  @spec new(children()) :: t()
  def new(children) do
    %__MODULE__{children: children}
  end

  @doc """
  Append one or more SVG children
  """
  def append(%__MODULE__{} = svg, children) when is_list(children) do
    Enum.reduce(children, svg, fn child, svg -> append(svg, child) end)
  end
  def append(%__MODULE__{} = svg, func) when is_function(func) do
    append(svg, func.())
  end
  def append(%__MODULE__{children: children} = svg, child) do
    %{svg | children: children ++ [child]}
  end

  defimpl Vectored.Renderable do
    def to_svg(%Vectored.Elements.Defs{children: children}) do
      child_elems = Enum.map(children, &Vectored.Renderable.to_svg/1)
      {:defs, [], child_elems}
    end
  end
end
