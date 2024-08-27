defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionNameAliases do
  @moduledoc false

  alias ElixirScribe.TemplateModuleAPI
  alias ElixirScribe.Generator.DomainContract

  @doc false
  def build(%DomainContract{} = context, opts) when is_list(opts) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions, reduce: "" do
      aliases ->
        aliases <>
          "\n  alias " <>
          TemplateModuleAPI.build_absolute_module_action_name(context, action, opts)
    end
  end
end
