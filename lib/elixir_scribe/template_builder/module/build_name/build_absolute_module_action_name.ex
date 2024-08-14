defmodule ElixirScribe.TemplateBuilder.Module.BuildName.BuildAbsoluteModuleActionName do
  @moduledoc false

  alias ElixirScribe.TemplateBuilderAPI
  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Utils.StringAPI

  def build(%DomainContract{} = _context, _action, [file_type: :html]), do: nil
  def build(%DomainContract{} = context, action, opts) when is_list(opts) do
    base_module = TemplateBuilderAPI.build_absolute_module_name(context, opts) |> inspect()
    module_action_name = TemplateBuilderAPI.build_module_action_name(context, action, opts)
    action_capitalized = action |> StringAPI.capitalize()

    "#{base_module}.#{action_capitalized}.#{module_action_name}"
  end
end
