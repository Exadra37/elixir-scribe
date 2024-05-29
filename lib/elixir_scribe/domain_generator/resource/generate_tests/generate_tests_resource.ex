defmodule ElixirScribe.DomainGenerator.Resource.GenerateTests.GenerateTestsResource do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def generate_tests(%Context{} = context, paths) do
    binding = MixGeneratorAPI.build_binding_template(context)

    ensure_test_file_exists(context, paths, binding)
    inject_tests(context, paths, binding)

    context
  end

  defp get_action_test_file(context, action) do
    ElixirScribe.build_app_resource_action_test_file_path(context, action, :test_core)
  end

  @doc false
  def ensure_test_file_exists(%Context{schema: schema} = context, paths, binding) do
    for action <- MixGeneratorAPI.build_actions_from_options(context.opts) do
      test_file = get_action_test_file(context, action)
      context = %{context | test_file: test_file}

      unless Context.pre_existing_tests?(context) do
        binding = ElixirScribe.rebuild_binding(binding, action)

        test_module_path =
          if schema.generate? do
            ElixirScribe.domain_tests_template_path() |> Path.join("action_test.exs")
          else
            ElixirScribe.domain_tests_template_path()
            |> Path.join("action_test_no_schema_access.exs")
          end

        Mix.Generator.create_file(
          test_file,
          Mix.Phoenix.eval_from(paths, test_module_path, binding)
        )
      end
    end
  end

  defp inject_tests(%Context{schema: schema} = context, paths, binding) do
    if schema.generate? do
      for action <- MixGeneratorAPI.build_actions_from_options(context.opts) do
        test_file = get_action_test_file(context, action)
        binding = ElixirScribe.rebuild_binding(binding, action)

        schema_folder = ElixirScribe.schema_template_folder_name(context.schema)

        action_template_filename =
          MixGeneratorAPI.build_template_action_filename(action, "schema_test.exs", "_")

        tests_path = ElixirScribe.domain_tests_template_path()

        test_action_file_path =
          Path.join([tests_path, "actions", schema_folder, action_template_filename])

        paths
        |> Mix.Phoenix.eval_from(test_action_file_path, binding)
        |> MixGeneratorAPI.inject_eex_before_final_end(test_file, binding)
      end
    end
  end
end
