defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias ElixirScribe.MixGeneratorAPI
  alias Mix.Scribe.Context
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%Context{} = _context, _action, [file_type: :html]), do: ""
  def build(%Context{} = context, action, opts) when is_list(opts) do
    # base_module = base_module(context, opts) |> inspect()
    base_module = MixGeneratorAPI.build_absolute_module_name(context, opts)
    module_action_name = MixGeneratorAPI.build_module_action_name(context, action, opts)
    action_capitalized = action |> StringAPI.capitalize()

    "#{base_module}.#{action_capitalized}.#{module_action_name}"
  end

  # @core_resources [:resource, :lib_core, :test_core]
  # defp base_module(context, [file_type: type]) when type in @core_resources, do: context.resource_module

  # @web_resources [:lib_web, :controller, :controller_test, :test_web]
  # defp base_module(context, [file_type: type]) when type in @web_resources, do: context.web_resource_module
end
