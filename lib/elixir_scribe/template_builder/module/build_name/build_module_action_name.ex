defmodule ElixirScribe.TemplateBuilder.Module.BuildName.BuildModuleActionName do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%DomainContract{} = context, action) when is_binary(action) do
    schema =
      (action in ElixirScribe.resource_plural_actions() && context.schema.human_plural) ||
        context.schema.human_singular

    schema = schema |> StringAPI.capitalize()

    action_capitalized = action |> StringAPI.capitalize()

    "#{action_capitalized}#{schema}"
  end
end
