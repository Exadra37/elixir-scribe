defmodule ElixirScribe.DomainGenerator.Resource.GenerateNewFiles.GenerateNewFilesResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.DomainGenerator.ResourceAPI

  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def generate(%Context{generate?: false} = context), do: context
  def generate(%Context{generate?: true} = context), do: generate_new_files(context)

  defp generate_new_files(%Context{schema: schema} = context, opts \\ []) when is_list(opts) do
    prompt_for_conflicts? = Keyword.get(opts, :prompt_for_conflicts?, true)

    unless prompt_for_conflicts? do
      prompt_for_conflicts(context)
    end

    paths = ElixirScribe.base_template_paths()
    binding = MixGeneratorAPI.build_binding_template(context)

    # @TODO Remove once Mix.Phoenix.Schema is ported to Mix.Scribe.Schema
    attrs = Map.from_struct(schema)
    schema = struct(Mix.Phoenix.Schema, attrs)

    if schema.generate?, do: Mix.Tasks.Phx.Gen.Schema.copy_new_files(schema, paths, binding)

    context
    |> ResourceAPI.generate_api()
    |> ResourceAPI.generate_actions()
    |> ResourceAPI.generate_tests()
    |> ResourceAPI.generate_test_fixture()

    context
  end

  defp prompt_for_conflicts(context) do
    api_file = [ResourceAPI.build_api_file_paths(context)]
    resource_files = ResourceAPI.build_action_files_paths(context)
    schema_files = Mix.Tasks.Phx.Gen.Schema.files_to_be_generated(context.schema)

    api_file
    |> Kernel.++(resource_files)
    |> Kernel.++(schema_files)
    |> MixGeneratorAPI.prompt_for_conflicts()
  end
end
