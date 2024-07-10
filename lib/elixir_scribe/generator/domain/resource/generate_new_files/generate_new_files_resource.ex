defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI

  alias ElixirScribe.TemplateBuilderAPI

  @doc false
  def generate(%DomainContract{generate?: false} = context), do: context
  def generate(%DomainContract{generate?: true} = context), do: generate_new_files(context)

  defp generate_new_files(%DomainContract{} = context, opts \\ []) when is_list(opts) do
    prompt_for_conflicts? = Keyword.get(opts, :prompt_for_conflicts?, true)

    unless prompt_for_conflicts? do
      prompt_for_conflicts(context)
    end

    schema = ElixirScribe.to_phoenix_schema(context.schema)
    paths = ElixirScribe.base_template_paths()
    binding = TemplateBuilderAPI.build_binding_template(context)

    if schema.generate?, do: Mix.Tasks.Phx.Gen.Schema.copy_new_files(schema, paths, binding)

    context
    |> ResourceAPI.generate_api()
    |> ResourceAPI.generate_actions()
    |> ResourceAPI.generate_tests()
    |> ResourceAPI.generate_test_fixture()

    context
  end

  defp prompt_for_conflicts(context) do
    context
    |> ResourceAPI.build_files_to_generate()
    |> TemplateBuilderAPI.prompt_for_conflicts()
  end
end