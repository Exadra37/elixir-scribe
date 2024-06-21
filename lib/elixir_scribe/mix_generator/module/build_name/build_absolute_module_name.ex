defmodule ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleName do
  @moduledoc false

  alias Mix.Scribe.Context
  # alias ElixirScribe.Utils.StringAPI

  @doc false
  # def build(%Context{} = context, opts) when is_list(opts) do
  #   from_schema? = opts |> Keyword.get(:from_schema, true)
  #   (from_schema? && inspect(context.schema.module)) || inspect(context.module)
  #   |> StringAPI.capitalize()
      # end

  def build(%Context{} = _context, [file_type: :html]), do: ""
  def build(%Context{} = context, opts) when is_list(opts), do: base_module(context, opts)

  @core_resources [:resource, :lib_core, :test_core]
  defp base_module(context, [file_type: type]) when type in @core_resources, do: context.resource_module

  @web_resources [:lib_web, :controller, :controller_test, :test_web]
  defp base_module(context, [file_type: type]) when type in @web_resources, do: context.web_resource_module
end
