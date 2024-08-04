Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.Domain.ResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the Resource API file", config do
    in_tmp_project(config.test, fn ->
      ### GENERATING FILES ###

      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "secret:redact",
        "title:string",
        "--actions",
        "export,import"
      ]

      contract = domain_contract_fixture(args)
      ResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/blog/post_api.ex", fn file ->
        assert file =~ "def read!(id)"
        assert file =~ "def list()"
        assert file =~ "def create(attrs)"
        assert file =~ "def update(id, attrs)"
        assert file =~ "def delete(id)"
        assert file =~ "def new(attrs \\\\ %{})"
        assert file =~ "def edit(id, attrs \\\\ %{})"
        assert file =~ "def import()"
        assert file =~ "def export()"
      end)
    end)
  end
end
