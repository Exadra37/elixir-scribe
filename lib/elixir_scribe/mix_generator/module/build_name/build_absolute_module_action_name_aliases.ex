defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionNameAliases do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def build(%Context{} = context, opts) when is_list(opts) do
    for action <- MixGeneratorAPI.build_actions_from_options(context.opts), reduce: "" do
      aliases ->
        aliases <>
          "\n  alias " <> MixGeneratorAPI.build_absolute_module_action_name(context, action, opts)
    end
  end
end
