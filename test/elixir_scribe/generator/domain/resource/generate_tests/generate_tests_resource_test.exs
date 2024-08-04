Code.require_file("../../../../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.Domain.Resource.GenerateTests.GenerateTestsResourceTest do

  alias ElixirScribe.Generator.Domain.ResourceAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates a file for each Resource Action", config do
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

      ResourceAPI.generate_tests(contract)

      assert_file("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPostsTest do"
        assert file =~ "test \"list/0"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/new/new_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPostTest do"
        assert file =~ "test \"new/0"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/read/read_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPostTest do"
        assert file =~ "test \"read!/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/edit/edit_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPostTest do"
        assert file =~ "test \"edit/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/create/create_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePostTest do"
        assert file =~ "test \"create/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/update/update_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePostTest do"
        assert file =~ "test \"update/2"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/delete/delete_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePostTest do"
        assert file =~ "test \"delete/1"
      end)
    end)
  end
 end
