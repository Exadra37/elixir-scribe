Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResourceTest do

  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.Domain.ResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generate_new_files/1 creates all actions for a resource of a domain, including the schema, migration, tests and fixtures", config do
    in_tmp_project(config.test, fn ->

      ### GENERATING FILES ###

      args = ["Blog", "Post", "posts", "slug:unique", "secret:redact", "title:string", "--actions", "export,import"]
      domain_contract = domain_contract_fixture(args)
      ResourceAPI.generate_new_files(domain_contract)


      ### RESOURCE SCHEMA ###

      assert_file("lib/elixir_scribe/domain/blog/post/post_schema.ex", fn file ->
        assert file =~ "field :title, :string"
        assert file =~ "field :secret, :string, redact: true"
      end)


      ### RESOURCE API ###

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

      assert_file("lib/elixir_scribe/domain/blog/post/list/list_posts.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPosts do"
        assert file =~ "def list()"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPostsTest do"
        assert file =~ "test \"list/0"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/new/new_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPost do"
        assert file =~ "def new(attrs \\\\ %{})"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/new/new_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPostTest do"
        assert file =~ "test \"new/0"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/read/read_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPost do"
        assert file =~ "def read!(id)"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/read/read_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPostTest do"
        assert file =~ "test \"read!/1"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/edit/edit_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPost do"
        assert file =~ "def edit(id, attrs \\\\ %{})"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/edit/edit_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPostTest do"
        assert file =~ "test \"edit/1"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/create/create_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePost do"
        assert file =~ "def create(%{} = attrs)"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/create/create_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePostTest do"
        assert file =~ "test \"create/1"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/update/update_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePost do"
        assert file =~ "def update(id, %{} = attrs)"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/update/update_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePostTest do"
        assert file =~ "test \"update/2"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/delete/delete_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePost do"
        assert file =~ "def delete(id)"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/delete/delete_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePostTest do"
        assert file =~ "test \"delete/1"
      end)


      ### TEST FIXTURES ###

      assert_file("test/support/fixtures/domain/blog/post_fixtures.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.PostFixtures do"
        assert file =~ "def post_fixture(attrs \\\\ %{})"
        assert file =~ "title: \"some title\""
      end)

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
