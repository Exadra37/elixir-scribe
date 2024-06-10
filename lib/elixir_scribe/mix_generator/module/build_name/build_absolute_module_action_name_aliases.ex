defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionNameAliases do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def build(%Context{} = context, opts) when is_list(opts) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions, reduce: "" do
      aliases ->
        aliases <>
          "\n  alias " <> MixGeneratorAPI.build_absolute_module_action_name(context, action, opts)
    end
  end
end
