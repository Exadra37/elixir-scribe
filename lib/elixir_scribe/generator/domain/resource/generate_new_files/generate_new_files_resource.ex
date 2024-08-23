defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI
  alias ElixirScribe.TemplateBuilderAPI

  def generate(%DomainContract{generate?: false} = contract, _opts), do: contract
  def generate(%DomainContract{generate?: true} = contract, opts), do: generate_new_files(contract, opts)

  defp generate_new_files(%DomainContract{} = contract, opts) when is_list(opts) do
    prompt_for_conflicts? = Keyword.get(opts, :prompt_for_conflicts?, true)

    unless prompt_for_conflicts? do
      prompt_for_conflicts(contract)
    end

    contract
    |> ResourceAPI.generate_api()
    |> ResourceAPI.generate_schema()
    |> ResourceAPI.generate_actions()
    |> ResourceAPI.generate_tests()
    |> ResourceAPI.generate_test_fixture()

    contract
  end

  defp prompt_for_conflicts(contract) do
    contract
    |> ResourceAPI.build_files_to_generate()
    |> TemplateBuilderAPI.prompt_for_conflicts()
  end
end
