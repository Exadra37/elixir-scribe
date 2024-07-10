defmodule ElixirScribe.Generator.Schema.SchemaContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.Schema.SchemaContract
  alias ElixirScribe.Generator.Schema.ResourceAPI

  test "new!/1 Creates a Schema Contract" do
    args = ["Blog", "Post", "posts", "title:string", "desc:string"]

    expected_domain_contract = %SchemaContract{}

    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    opts = Keyword.put(opts, :web, "Blog")

    assert domain_contract = %SchemaContract{} = SchemaContract.new!(valid_args, opts)

    assert expected_domain_contract === domain_contract
  end

  test "new!/1 Creates a one level nested Schema Contract" do
    args = ["Blog.Site", "Post", "posts", "title:string", "desc:string"]

    expected_domain_contract = %SchemaContract{}

    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    opts = Keyword.put(opts, :web, "Blog")

    assert domain_contract = %SchemaContract{} = SchemaContract.new!(valid_args, opts)

    assert expected_domain_contract === domain_contract
  end

  test "new!/1 Creates a two level nested Schema Contract" do
    args = ["Blog.Site.Admin", "Post", "posts", "title:string", "desc:string"]

    expected_domain_contract = %SchemaContract{}

    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    opts = Keyword.put(opts, :web, "Blog")

    assert domain_contract = %SchemaContract{} = SchemaContract.new!(valid_args, opts)

    assert expected_domain_contract === domain_contract
  end
end
