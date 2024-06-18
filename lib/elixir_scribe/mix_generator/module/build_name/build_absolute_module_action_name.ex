defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias ElixirScribe.MixGeneratorAPI
  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = context, action, opts) when is_list(opts) do
    from_schema? = opts |> Keyword.get(:from_schema, true)

    module_prefix = (from_schema? && inspect(context.schema.module)) || inspect(context.module)

    action_capitalized = action |> StringAPI.capitalize()

    module_action_name = MixGeneratorAPI.build_module_action_name(context, action, opts)

    "#{module_prefix}.#{action_capitalized}.#{module_action_name}"
  end
end
