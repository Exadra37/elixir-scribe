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
    |> ResourceAPI.generate_api(paths)
    |> ResourceAPI.generate_actions(paths)
    |> ResourceAPI.generate_tests(paths)
    |> ResourceAPI.generate_test_fixture(paths)

    context
  end

  defp prompt_for_conflicts(context) do
    schema_files = Mix.Tasks.Phx.Gen.Schema.files_to_be_generated(context.schema)

    context
    |> ResourceAPI.files_to_generate()
    |> Kernel.++(schema_files)
    |> MixGeneratorAPI.prompt_for_conflicts()
  end
end
