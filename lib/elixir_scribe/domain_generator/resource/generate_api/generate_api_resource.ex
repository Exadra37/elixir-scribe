defmodule ElixirScribe.DomainGenerator.Resource.GenerateApi.GenerateApiResource do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def generate(%Context{} = context, paths) do
    binding = ElixirScribe.build_binding(context)

    ensure_api_file_exists(context, paths, binding)
    inject_api_functions(context, paths, binding)

    context
  end

  defp get_api_file(context) do
    base_dir = ElixirScribe.build_app_domain_path(context, :lib_core)

    Path.join([base_dir, "#{context.schema.singular}_api.ex"])
  end

  defp build_api_binding(context, binding) do
    Keyword.merge(binding,
      module_name:
        ElixirScribe.MixGeneratorAPI.build_absolute_module_name(context, from_schema: true),
      aliases:
        ElixirScribe.MixGeneratorAPI.build_absolute_module_action_name_aliases(context,
          from_schema: true
        )
    )
    |> ElixirScribe.rebuild_binding_with_action_aliases()
  end

  @doc false
  def ensure_api_file_exists(context, paths, binding) do
    file = get_api_file(context)
    context = %{context | file: file}
    binding = build_api_binding(context, binding)

    unless Context.pre_existing?(context) do
      api_module_path =
        ElixirScribe.domain_api_template_path() |> Path.join("api_module.ex")

      Mix.Generator.create_file(
        file,
        Mix.Phoenix.eval_from(paths, api_module_path, binding)
      )
    end
  end

  defp inject_api_functions(context, paths, binding) do
    for action <- MixGeneratorAPI.build_actions_from_options(context.opts) do
      file = get_api_file(context)
      binding = build_api_binding(context, binding) |> ElixirScribe.rebuild_binding(action)

      api_action_template_path =
        if context.schema.generate? do
          action_template_filename =
            MixGeneratorAPI.build_template_action_filename(action, "api_function.ex", "_")

          ElixirScribe.domain_api_template_path() |> Path.join(action_template_filename)
        else
          ElixirScribe.domain_api_template_path()
          |> Path.join("api_function_no_schema_access.ex")
        end

      paths
      |> Mix.Phoenix.eval_from(api_action_template_path, binding)
      |> MixGeneratorAPI.inject_eex_before_final_end(file, binding)
    end
  end
end
