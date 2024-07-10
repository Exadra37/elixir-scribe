defmodule ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContract
  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI


  test "build!/2 returns a %DomainContract{}" do
    args = ["Blog", "Post", "posts", "name:string"]
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    context = BuildDomainResourceContract.build!(valid_args, opts)

    # Exhaustive tests can be found at: test/elixir_scribe/generator/domain/domain_contract_test.exs
    assert %DomainContract{} = context
  end
end
