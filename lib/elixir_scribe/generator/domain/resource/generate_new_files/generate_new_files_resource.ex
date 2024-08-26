defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.DomainResourceAPI
  alias ElixirScribe.TemplateFileAPI

  def generate(%DomainContract{generate?: false} = contract, _opts), do: contract
  def generate(%DomainContract{generate?: true} = contract, opts), do: generate_new_files(contract, opts)

  defp generate_new_files(%DomainContract{} = contract, opts) when is_list(opts) do
    prompt_for_conflicts? = Keyword.get(opts, :prompt_for_conflicts?, true)

    unless prompt_for_conflicts? do
      prompt_for_conflicts(contract)
    end

    contract
    |> DomainResourceAPI.generate_api()
    |> DomainResourceAPI.generate_schema()
    |> DomainResourceAPI.generate_actions()
    |> DomainResourceAPI.generate_tests()
    |> DomainResourceAPI.generate_test_fixture()

    contract
  end

  defp prompt_for_conflicts(contract) do
    contract
    |> DomainResourceAPI.build_files_to_generate()
    |> TemplateFileAPI.prompt_for_conflicts()
  end
end
