defmodule ElixirScribe.Template.Module.BuildName.BuildModuleActionName do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%DomainContract{} = context, action) when is_binary(action) do
    resource =
      (action in ElixirScribe.resource_plural_actions() && context.schema.human_plural) ||
        context.schema.human_singular

    resource = resource |> StringAPI.capitalize()

    action_capitalized = action |> StringAPI.capitalize()

    "#{action_capitalized}#{resource}"
  end
end
