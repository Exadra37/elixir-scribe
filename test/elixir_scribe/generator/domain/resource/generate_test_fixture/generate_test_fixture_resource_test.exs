Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.DomainResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the file for the resource test fixture", config do
    in_tmp_project(config.test, fn ->
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

      DomainResourceAPI.generate_test_fixture(contract)

      assert_file("test/support/fixtures/domain/blog/post_fixtures.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.PostFixtures do"
        assert file =~ "def post_fixture(attrs \\\\ %{})"
        assert file =~ "title: \"some title\""
      end)
    end)
  end
end
