defmodule ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.TemplateBuilderAPI

  def generate(%DomainContract{generate?: false} = context), do: context
  def generate(%DomainContract{generate?: true} = context), do: generate_file(context)

  @doc false
  def generate_file(context) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = TemplateBuilderAPI.build_binding_template(context)

    ensure_test_fixtures_file_exists(context, base_template_paths, binding)
    inject_test_fixture(context, base_template_paths, binding)

    context
  end

  @doc false
  def ensure_test_fixtures_file_exists(
        %DomainContract{test_fixtures_file: test_fixtures_file} = context,
        base_template_paths,
        binding
      ) do
    unless DomainContract.pre_existing_test_fixtures?(context) do
      fixtures_module_template_path =
        ElixirScribe.domain_tests_template_path() |> Path.join("fixtures_module.ex")

      Mix.Generator.create_file(
        test_fixtures_file,
        Mix.Phoenix.eval_from(base_template_paths, fixtures_module_template_path, binding)
      )
    end
  end

  defp inject_test_fixture(
         %DomainContract{test_fixtures_file: test_fixtures_file} = context,
         base_template_paths,
         binding
       ) do
    ensure_test_fixtures_file_exists(context, base_template_paths, binding)

    fixtures_file_template_path =
      ElixirScribe.domain_tests_template_path() |> Path.join("fixtures.ex")

    base_template_paths
    |> Mix.Phoenix.eval_from(fixtures_file_template_path, binding)
    |> Mix.Phoenix.prepend_newline()
    |> TemplateBuilderAPI.inject_eex_before_final_end(test_fixtures_file, binding)

    maybe_print_unimplemented_fixture_functions(context)
  end

  defp maybe_print_unimplemented_fixture_functions(%DomainContract{} = context) do
    fixture_functions_needing_implementations =
      Enum.flat_map(
        context.schema.fixture_unique_functions,
        fn
          {_field, {_function_name, function_def, true}} -> [function_def]
          {_field, {_function_name, _function_def, false}} -> []
        end
      )

    if Enum.any?(fixture_functions_needing_implementations) do
      Mix.shell().info("""

      Some of the generated database columns are unique. Please provide
      unique implementations for the following fixture function(s) in
      #{context.test_fixtures_file}:

      #{fixture_functions_needing_implementations |> Enum.map_join(&indent(&1, 2)) |> String.trim_trailing()}
      """)
    end
  end

  defp indent(string, spaces) do
    indent_string = String.duplicate(" ", spaces)

    string
    |> String.split("\n")
    |> Enum.map_join(fn line ->
      if String.trim(line) == "" do
        "\n"
      else
        indent_string <> line <> "\n"
      end
    end)
  end
end
