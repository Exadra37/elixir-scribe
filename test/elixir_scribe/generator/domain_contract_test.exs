defmodule ElixirScribe.Generator.DomainContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI

  test "new!/1 Creates a new Domain Contract" do
    args = ["Blog", "Post", "posts", "title:string", "desc:string"]
    expected_domain_contract = domain_contract_fixture(args)

    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    opts = Keyword.put(opts, :web, "Blog")

    assert domain_contract = %DomainContract{} = DomainContract.new!(valid_args, opts)

    assert expected_domain_contract === domain_contract
  end
end
