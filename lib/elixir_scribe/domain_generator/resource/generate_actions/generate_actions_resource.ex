defmodule ElixirScribe.DomainGenerator.Resource.GenerateActions.GenerateActionsResource do
  @moduledoc false

  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias Mix.Phoenix.Context

  @doc false
  def generate(%Context{} = context, root_paths) do
    binding = ElixirScribe.build_binding(context)

    for {:eex, source_path, target_path, action} <- ResourceAPI.files_to_generate(context) do
      binding = ElixirScribe.rebuild_binding(binding, action)

      # When the file already exists we are asked if we want to overwrite it.
      created_or_overwritten? =
        create_action_module_file(root_paths, target_path, binding, context.schema.generate?)

      if created_or_overwritten? do
        inject_action_function_into_module(root_paths, source_path, target_path, binding)
      end
    end

    context
  end

  defp create_action_module_file(root_paths, target_path, binding, schema_generate?) do
    source_path = build_module_template_path(schema_generate?)

    ElixirScribe.create_file_from_template(root_paths, source_path, target_path, binding)
  end

  defp build_module_template_path(schema_generate?) do
    if schema_generate? do
      ElixirScribe.default_domain_actions_template_path() |> Path.join("action_module.ex")
    else
      ElixirScribe.default_domain_actions_template_path()
      |> Path.join("action_module_no_schema_access.ex")
    end
  end

  defp inject_action_function_into_module(root_paths, source_path, target_path, binding) do
    ElixirScribe.inject_into_file_from_template(root_paths, source_path, target_path, binding)
  end
end
