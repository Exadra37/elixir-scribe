defmodule ElixirScribe.TemplateBuilder.Module.BuildName.BuildModuleActionName do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = context, action, opts) when is_list(opts) do
    schema =
      (action in ElixirScribe.resource_plural_actions() && context.schema.human_plural) ||
        context.schema.human_singular

    schema = schema |> StringAPI.capitalize()

    action_capitalized = action |> StringAPI.capitalize()

    "#{action_capitalized}#{schema}"
  end
end
