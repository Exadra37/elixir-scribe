Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.DomainResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generate_new_files/1 creates all actions for a resource of a domain, including the schema, migration, tests and fixtures",
       config do
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

      domain_contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_new_files(domain_contract)

      ### RESOURCE SCHEMA ###

      assert File.exists?("lib/elixir_scribe/domain/blog/post/post_schema.ex") === true

      ### RESOURCE API ###

      assert File.exists?("lib/elixir_scribe/domain/blog/post_api.ex") === true

      # @TODO Uncomment when the domain generator creates the API test file
      # assert_file("test/elixir_scribe/domain/blog/post_api_test.exs", fn file ->
      #   assert file =~ "test \"read!/1"
      #   assert file =~ "test \"list/0"
      #   assert file =~ "test \"create/1"
      #   assert file =~ "test \"update/2"
      #   assert file =~ "test \"delete/1"
      #   assert file =~ "test \"new/0"
      #   assert file =~ "test \"edit/1"
      #   assert file =~ "test \"import/0"
      #   assert file =~ "test \"export/0"
      # end)

      ### RESOURCE ACTIONS ####

      assert File.exists?("lib/elixir_scribe/domain/blog/post/list/list_posts.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/new/new_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/new/new_post_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/read/read_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/read/read_post_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/edit/edit_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/edit/edit_post_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/create/create_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/create/create_post_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/update/update_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/update/update_post_test.exs") === true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/delete/delete_post.ex") === true

      assert File.exists?("test/elixir_scribe/domain/blog/post/delete/delete_post_test.exs") === true

      ### TEST FIXTURES ###

      assert File.exists?("test/support/fixtures/domain/blog/post_fixtures.ex") === true

      ### MIGRATIONS ###

      assert [path] = Path.wildcard("priv/repo/migrations/*_create_posts.exs")

      assert_file(path, fn file ->
        assert file =~ "create table(:posts"
        assert file =~ "add :title, :string"
        assert file =~ "add :secret, :string"
        assert file =~ "create unique_index(:posts, [:slug])"
      end)
    end)
  end
end
