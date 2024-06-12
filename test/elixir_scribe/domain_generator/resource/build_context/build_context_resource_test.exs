defmodule ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource
  alias Mix.Scribe.Context
  alias ElixirScribe.DomainGenerator.ResourceAPI


  test "builds Mix.Scribe.Context" do
    args = ["Blog", "Post", "posts"]
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    context = BuildContextResource.build!(valid_args, opts, __MODULE__)

    assert %Context{
             alias: Blog,
             base_module: ElixirScribe,
             basename: "blog",
             module: ElixirScribe.Blog,
             web_module: ElixirScribeWeb,
             schema: %Mix.Scribe.Schema{
               alias: Post,
               human_plural: "Posts",
               human_singular: "Post",
               module: ElixirScribe.Blog.Post,
               plural: "posts",
               singular: "post"
             }
           } = context

    assert String.ends_with?(context.lib_domain_dir, "lib/elixir_scribe/domain/blog")
    assert String.ends_with?(context.api_file, "lib/elixir_scribe/domain/blog/post_api.ex")
    assert String.ends_with?(context.test_file, "test/elixir_scribe/domain/blog_test.exs")

    assert String.ends_with?(
             context.test_fixtures_file,
             "test/support/fixtures/domain/blog_fixtures.ex"
           )

    assert String.ends_with?(context.schema.file, "lib/elixir_scribe/domain/blog/post/post_schema.ex")
  end

  test "builds nested Mix.Scribe.Context" do
    args = ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    context = BuildContextResource.build!(valid_args, opts, __MODULE__)

    assert %Context{
             alias: Blog,
             base_module: ElixirScribe,
             basename: "blog",
             module: ElixirScribe.Site.Blog,
             web_module: ElixirScribeWeb,
             schema: %Mix.Scribe.Schema{
               alias: Post,
               human_plural: "Posts",
               human_singular: "Post",
               module: ElixirScribe.Site.Blog.Post,
               plural: "posts",
               singular: "post"
             }
           } = context

    assert String.ends_with?(context.lib_domain_dir, "lib/elixir_scribe/domain/site/blog")
    assert String.ends_with?(context.api_file, "lib/elixir_scribe/domain/site/blog/post_api.ex")
    assert String.ends_with?(context.test_file, "test/elixir_scribe/domain/site/blog_test.exs")

    assert String.ends_with?(
             context.test_fixtures_file,
             "test/support/fixtures/domain/site/blog_fixtures.ex"
           )

    assert String.ends_with?(context.schema.file, "lib/elixir_scribe/domain/site/blog/post/post_schema.ex")
  end
end
