defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = context, action, opts) when is_list(opts) do
    schema =
      (action in ElixirScribe.resource_plural_actions() && context.schema.human_plural) ||
        context.schema.human_singular

    from_schema? = opts |> Keyword.get(:from_schema, true)
    module_prefix = (from_schema? && inspect(context.schema.module)) || inspect(context.module)

    action_capitalized = action |> StringAPI.capitalize()

    "#{module_prefix}.#{action_capitalized}.#{action_capitalized}#{schema}"
  end
end
