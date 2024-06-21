defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias ElixirScribe.MixGeneratorAPI
  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = _context, _action, [type: type]) when type in [:html], do: ""
  def build(%Context{} = context, action, opts) when is_list(opts) do
    module_prefix = base_module(context, opts) |> inspect()
    module_action_name = MixGeneratorAPI.build_module_action_name(context, action, opts)
    action_capitalized = action |> StringAPI.capitalize()

    "#{module_prefix}.#{action_capitalized}.#{module_action_name}"
  end

  defp base_module(context, [type: type]) when type in [:resource, :lib_core, :test_core], do: context.resource_module

  # defp base_module(context, [type: type]) when type in [:resource, :lib_core], do: context.resource_module

  # defp base_module(context, [type: type]) when type in [:resource_test, :test_core], do: context.resource_module_plural

  # defp base_module(context, [type: type]) when type in [:resource_test, :test_core], do: context.resource_module

  # defp base_module(context, [type: :controller]), do: context.web_resource_module

  # defp base_module(context, [type: :controller_test]), do: context.web_resource_module

  # defp base_module(context, [type: type]) when type in [::controller_test, do: context.web_resource_module
  defp base_module(context, [type: type]) when type in [:lib_web, :controller, :controller_test, :test_web], do: context.web_resource_module

  # We don't care
  # defp base_module(_context, _opts), do: nil
end
