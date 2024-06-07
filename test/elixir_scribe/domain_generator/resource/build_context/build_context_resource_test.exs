defmodule ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResourceTest do
  use ExUnit.Case

  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource
  alias Mix.Phoenix.Context
  alias ElixirScribe.DomainGenerator.ResourceAPI


  test "builds Mix.Phoenix.Context" do
    args = ["Blog", "Post", "posts"]
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    context = BuildContextResource.build!(valid_args, opts, __MODULE__)

    assert %Context{
             alias: Blog,
             base_module: ElixirScribe,
             basename: "blog",
             module: ElixirScribe.Blog,
             web_module: ElixirScribeWeb,
             schema: %Mix.Phoenix.Schema{
               alias: Post,
               human_plural: "Posts",
               human_singular: "Post",
               module: ElixirScribe.Blog.Post,
               plural: "posts",
               singular: "post"
             }
           } = context

    assert String.ends_with?(context.dir, "lib/elixir_scribe/blog")
    assert String.ends_with?(context.file, "lib/elixir_scribe/blog.ex")
    assert String.ends_with?(context.test_file, "test/elixir_scribe/blog_test.exs")

    assert String.ends_with?(
             context.test_fixtures_file,
             "test/support/fixtures/blog_fixtures.ex"
           )

    assert String.ends_with?(context.schema.file, "lib/elixir_scribe/blog/post.ex")
  end

  test "builds nested Mix.Phoenix.Context" do
    args = ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args() |> dbg()

    context = BuildContextResource.build!(valid_args, opts, __MODULE__)

    assert %Context{
             alias: Blog,
             base_module: ElixirScribe,
             basename: "blog",
             module: ElixirScribe.Site.Blog,
             web_module: ElixirScribeWeb,
             schema: %Mix.Phoenix.Schema{
               alias: Post,
               human_plural: "Posts",
               human_singular: "Post",
               module: ElixirScribe.Site.Blog.Post,
               plural: "posts",
               singular: "post"
             }
           } = context

    assert String.ends_with?(context.dir, "lib/elixir_scribe/site/blog")
    assert String.ends_with?(context.file, "lib/elixir_scribe/site/blog.ex")
    assert String.ends_with?(context.test_file, "test/elixir_scribe/site/blog_test.exs")

    assert String.ends_with?(
             context.test_fixtures_file,
             "test/support/fixtures/site/blog_fixtures.ex"
           )

    assert String.ends_with?(context.schema.file, "lib/elixir_scribe/site/blog/post.ex")
  end
end
