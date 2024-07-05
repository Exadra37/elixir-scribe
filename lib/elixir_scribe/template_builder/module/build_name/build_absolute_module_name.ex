defmodule ElixirScribe.TemplateBuilder.Module.BuildName.BuildAbsoluteModuleName do
  @moduledoc false

  alias Mix.Scribe.Context

  def build(%Context{} = _context, [file_type: :html]), do: nil
  def build(%Context{} = context, opts) when is_list(opts), do: module_name(context, opts)

  @core_files [:resource, :resource_test, :lib_core, :test_core]
  defp module_name(context, [file_type: type]) when type in @core_files, do: context.resource_module

  @web_files [:lib_web, :controller, :controller_test, :test_web]
  defp module_name(context, [file_type: type]) when type in @web_files, do: context.web_resource_module
end
