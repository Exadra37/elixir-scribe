defmodule ElixirScribe.DomainGenerator.Resource.BuildFilesToGenerate.BuildFilesToGenerateResource do
  @moduledoc false

  alias ElixirScribe.DomainGenerator.ResourceAPI
  alias Mix.Scribe.Context

  @doc false
  def build(%Context{generate?: false}), do: []
  def build(%Context{generate?: true} = context), do: build_files(context)

  def build_files(context) do
    api_file = [ResourceAPI.build_api_file_paths(context)]
    resource_files = ResourceAPI.build_action_files_paths(context)
    schema_files = Mix.Tasks.Phx.Gen.Schema.files_to_be_generated(context.schema)
     %Context{test_fixtures_file: test_fixtures_file} = context

    api_file
    |> Kernel.++(resource_files)
    |> Kernel.++(schema_files)
    |> Kernel.++([test_fixtures_file])
  end
end
