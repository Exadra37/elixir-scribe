defmodule ElixirScribe.DomainGenerator.Resource.GenerateTests.GenerateTestsResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def generate_tests(%Context{} = context) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = MixGeneratorAPI.build_binding_template(context)

    context
    |> ensure_test_file_exists(base_template_paths, binding)
    |> inject_tests(base_template_paths, binding)

    context
  end

  defp get_action_test_file(context, action) do
    plural_actions = ElixirScribe.resource_plural_actions()
    resource_name = action in plural_actions && context.resource_name_plural || context.resource_name_singular
    filename = "#{action}_" <> resource_name <> "_test.exs"
    Path.join([context.test_resource_dir, action, filename])
  end

  defp ensure_test_file_exists(%Context{schema: schema} = context, base_template_paths, binding) do
    resource_actions = context.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
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
          Mix.Phoenix.eval_from(base_template_paths, test_module_path, binding)
        )
      end
    end

    context
  end

  defp inject_tests(%Context{schema: schema} = context, base_template_paths, binding) do
    if schema.generate? do
      resource_actions = context.opts |> Keyword.get(:resource_actions)

      for action <- resource_actions do
        test_file = get_action_test_file(context, action)
        binding = MixGeneratorAPI.rebuild_binding_template(binding, action)

        schema_folder = ElixirScribe.schema_template_folder_name(context.schema)

        action_template_filename =
          MixGeneratorAPI.build_template_action_filename(action, "_", "schema_test", ".exs")

        tests_path = ElixirScribe.domain_tests_template_path()

        test_action_file_path =
          Path.join([tests_path, "actions", schema_folder, action_template_filename])

        base_template_paths
        |> Mix.Phoenix.eval_from(test_action_file_path, binding)
        |> MixGeneratorAPI.inject_eex_before_final_end(test_file, binding)
      end
    end
  end
end
