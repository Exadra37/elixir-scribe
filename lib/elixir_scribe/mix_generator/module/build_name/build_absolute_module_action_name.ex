defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias ElixirScribe.MixGeneratorAPI
  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = context, action, opts) when is_list(opts) do
    # plural_action? = action in ElixirScribe.resource_plural_actions()
    plural_action? = false

    module_prefix = base_module(context, opts, plural_action?: plural_action?) |> inspect()
    module_action_name = MixGeneratorAPI.build_module_action_name(context, action, opts)
    action_capitalized = action |> StringAPI.capitalize()

    "#{module_prefix}.#{action_capitalized}.#{module_action_name}"
    |> dbg()
  end

  defp base_module(context, [type: type], plural_action?: true) when type in [:resource, :lib_core], do: context.resource_module_plural

  defp base_module(context, [type: type], plural_action?: false) when type in [:resource, :lib_core], do: context.resource_module

  defp base_module(context, [type: type], plural_action?: true) when type in [:resource_test, :test_core], do: Module.concat(context.resource_module_plural, "Test")

  defp base_module(context, [type: type], plural_action?: false) when type in [:resource_test, :test_core], do: Module.concat(context.resource_module, "Test")

  defp base_module(context, [type: :lib_web], plural_action?: true), do: context.web_resource_module_plural

  defp base_module(context, [type: :lib_web], plural_action?: false), do: context.web_resource_module

  # defp base_module(context, [type: :controller], plural_action?: true), do: Module.concat(context.web_resource_module_plural, "Controller")
  defp base_module(context, [type: :controller], plural_action?: true), do: context.web_resource_module_plural

  # defp base_module(context, [type: :controller], plural_action?: false), do: Module.concat(context.web_resource_module, "Controller")
  defp base_module(context, [type: :controller], plural_action?: false), do: context.web_resource_module

  # defp base_module(context, [type: :controller_test], plural_action?: true), do: Module.concat(context.web_resource_module_plural, "ControllerTest")
  defp base_module(context, [type: :controller_test], plural_action?: true), do: context.web_resource_module_plural

  # defp base_module(context, [type: :controller_test], plural_action?: false), do: Module.concat(context.web_resource_module, "ControllerTest")
  defp base_module(context, [type: :controller_test], plural_action?: false), do: context.web_resource_module

  defp base_module(_context, _opts, _plural_action?), do: nil
end
