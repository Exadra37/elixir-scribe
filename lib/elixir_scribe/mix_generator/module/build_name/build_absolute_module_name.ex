defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleName do
  @moduledoc false

  alias Mix.Phoenix.Context

  @doc false
  def build(%Context{} = context, opts) when is_list(opts) do
    from_schema? = opts |> Keyword.get(:from_schema, true)
    (from_schema? && inspect(context.schema.module)) || inspect(context.module)
  end
end
