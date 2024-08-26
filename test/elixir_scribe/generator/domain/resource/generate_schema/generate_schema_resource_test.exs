Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateSchema.GenerateSchemaResourceTest do
alias ElixirScribe.Generator.Domain.ResourceAPI

  use ElixirScribe.BaseCase
  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the Resource Schema file", config do
    in_tmp_project(config.test, fn ->
      contract = domain_contract_fixture()
      ResourceAPI.generate_schema(contract)

      assert_file("lib/elixir_scribe/domain/site/blog/post/post_schema.ex", fn file ->
        assert file =~ "field :name, :string"
        assert file =~ "field :desc, :string"
      end)
    end)
  end
end
