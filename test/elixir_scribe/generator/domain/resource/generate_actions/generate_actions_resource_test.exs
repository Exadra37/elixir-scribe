Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateActions.GenerateActionsResourceTest do
  alias ElixirScribe.Generator.Domain.ResourceAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates a file for each Resource Action", config do
    in_tmp_project(config.test, fn ->
      args = ["Blog", "Post", "posts", "slug:unique", "secret:redact", "title:string", "--actions", "export,import"]

      contract = domain_contract_fixture(args)

      ResourceAPI.generate_actions(contract)

      assert_file("lib/elixir_scribe/domain/blog/post/list/list_posts.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPosts do"
        assert file =~ "def list()"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/new/new_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPost do"
        assert file =~ "def new(attrs \\\\ %{})"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/read/read_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPost do"
        assert file =~ "def read!(id)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/edit/edit_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPost do"
        assert file =~ "def edit(id, attrs \\\\ %{})"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/create/create_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePost do"
        assert file =~ "def create(%{} = attrs)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/update/update_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePost do"
        assert file =~ "def update(id, %{} = attrs)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/delete/delete_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePost do"
        assert file =~ "def delete(id)"
      end)
    end)
  end
end
