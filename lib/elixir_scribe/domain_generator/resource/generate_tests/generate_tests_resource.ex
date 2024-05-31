defmodule ElixirScribe.DomainGenerator.Resource.GenerateTests.GenerateTestsResource do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI
  alias ElixirScribe.MixGenerator.AppApi
  alias ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract

  @doc false
  def generate_tests(%Context{} = context, paths) do
    binding = MixGeneratorAPI.build_binding_template(context)

    ensure_test_file_exists(context, paths, binding)
    inject_tests(context, paths, binding)

    context
  end

  defp get_action_test_file(context, action) do
    # ElixirScribe.build_app_resource_action_test_file_path(context, action, :test_core)
    api_contract = BuildResourceActionFilePathContract.new!(%{
      context: context,
      action: action,
      file_extension: ".exs",
      file_type: "_test",
      path_type: :test_core
    })

    AppApi.build_resource_action_file_path(api_contract)
  end

  @doc false
  def ensure_test_file_exists(%Context{schema: schema} = context, paths, binding) do
    for action <- MixGeneratorAPI.build_actions_from_options(context.opts) do
      test_file = get_action_test_file(context, action)
      context = %{context | test_file: test_file}

      unless Context.pre_existing_tests?(context) do
        binding = MixGeneratorAPI.rebuild_binding_template(binding, action)

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
        binding = MixGeneratorAPI.rebuild_binding_template(binding, action)

        schema_folder = ElixirScribe.schema_template_folder_name(context.schema)

        action_template_filename =
          MixGeneratorAPI.build_template_action_filename(action, "_", "schema_test", ".exs")

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
