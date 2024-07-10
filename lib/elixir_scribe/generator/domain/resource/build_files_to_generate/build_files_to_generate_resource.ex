defmodule ElixirScribe.Generator.Domain.Resource.BuildFilesToGenerate.BuildFilesToGenerateResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.ResourceAPI
  alias ElixirScribe.Generator.Domain.DomainContract

  @doc false
  def build(%DomainContract{generate?: false}), do: []
  def build(%DomainContract{generate?: true} = context), do: build_files(context)

  def build_files(context) do
    api_file = [ResourceAPI.build_api_file_paths(context)]
    resource_files = ResourceAPI.build_action_files_paths(context)
    resource_test_files = ResourceAPI.build_test_action_files_paths(context)
    schema = ElixirScribe.to_phoenix_schema(context.schema)
    schema_files = Mix.Tasks.Phx.Gen.Schema.files_to_be_generated(schema)
    test_fixtures_file = build_test_fixture_file(context)

    api_file
    |> Kernel.++(resource_files)
    |> Kernel.++(resource_test_files)
    |> Kernel.++(schema_files)
    |> Kernel.++(test_fixtures_file)
  end

  defp build_test_fixture_file(%DomainContract{test_fixtures_file: test_fixtures_file}) do
    source_path = ElixirScribe.domain_tests_template_path() |> Path.join("fixtures_module.ex")

    [{:eex, source_path, test_fixtures_file}]
  end
end
