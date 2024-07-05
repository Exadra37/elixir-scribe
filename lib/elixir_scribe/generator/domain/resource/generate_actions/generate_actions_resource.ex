defmodule ElixirScribe.Generator.Domain.Resource.GenerateActions.GenerateActionsResource do
  @moduledoc false

  alias ElixirScribe.TemplateBuilderAPI
  alias ElixirScribe.Generator.Domain.ResourceAPI
  alias Mix.Scribe.Context

  @doc false
  def generate(%Context{} = context) do
    base_template_paths = ElixirScribe.base_template_paths()

    binding = TemplateBuilderAPI.build_binding_template(context)

    for {:eex, :resource, source_path, target_path, action} <- ResourceAPI.build_action_files_paths(context) do

      binding = TemplateBuilderAPI.rebuild_binding_template(binding, action, file_type: :lib_core)

      # When the file already exists we are asked if we want to overwrite it.
      created_or_overwritten? =
        create_action_module_file(base_template_paths, target_path, binding, context.schema.generate?)

      if created_or_overwritten? do
        inject_action_function_into_module(base_template_paths, source_path, target_path, binding)
      end
    end

    context
  end

  defp create_action_module_file(base_template_paths, target_path, binding, schema_generate?) do
    module_template_path = build_module_template_path(schema_generate?)
    content = Mix.Phoenix.eval_from(base_template_paths, module_template_path, binding)

    Mix.Generator.create_file(target_path, content)
  end

  defp build_module_template_path(true) do
    ElixirScribe.resource_actions_template_path() |> Path.join("action_module.ex")
  end
  defp build_module_template_path(false) do
    ElixirScribe.resource_actions_template_path()
    |> Path.join("action_module_no_schema_access.ex")
  end

  defp inject_action_function_into_module(base_template_paths, source_path, target_path, binding) do
    base_template_paths
    |> Mix.Phoenix.eval_from(source_path, binding)
    |> TemplateBuilderAPI.inject_eex_before_final_end(target_path, binding)
  end
end
