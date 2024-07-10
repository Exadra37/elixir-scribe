defmodule ElixirScribe.Generator.Domain.DomainContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI

  test "new!/1 Creates a new Domain Contract" do
    args = ["Blog", "Post", "posts", "title:string", "desc:string"]

    expected_domain_contract = %DomainContract{
      alias: Blog,
      api_file: "lib/elixir_scribe/domain/blog/post_api.ex",
      base_module: ElixirScribe,
      basename: "blog",
      context_app: :elixir_scribe,
      generate?: true,
      lib_domain_dir: "lib/elixir_scribe/domain/blog",
      lib_resource_dir: "lib/elixir_scribe/domain/blog/post",
      lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/posts",
      lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog",
      lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/post",
      lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/posts",
      module: ElixirScribe.Blog,
      name: "Blog",
      opts: [
        {:web, "Blog"},
        {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
        {:schema, true},
        {:context, true},
        {:no_default_actions, false},
        {:actions, nil},
        {:binary_id, true}
      ],
      resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
      resource_module: ElixirScribe.Blog.Post,
      resource_module_plural: ElixirScribe.Blog.Posts,
      resource_name_plural: "posts",
      resource_name_singular: "post",
      schema: %ElixirScribe.Generator.Schema.SchemaContract{
        alias: Post,
        api_route_prefix: "/api/blog/posts",
        assocs: [],
        attrs: [{:title, :string}, {:desc, :string}],
        binary_id: true,
        collection: "posts",
        context_app: :elixir_scribe,
        defaults: %{title: "", desc: ""},
        embedded?: false,
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        fixture_params: [{:desc, "\"some desc\""}, {:title, "\"some title\""}],
        fixture_unique_functions: [],
        generate?: true,
        human_plural: "Posts",
        human_singular: "Post",
        indexes: [],
        migration?: true,
        migration_defaults: %{title: "", desc: ""},
        migration_module: Ecto.Migration,
        module: ElixirScribe.Blog.Post,
        optionals: [],
        opts: [
          {:web, "Blog"},
          {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
          {:schema, true},
          {:context, true},
          {:no_default_actions, false},
          {:actions, nil},
          {:binary_id, true}
        ],
        params: %{
          create: %{title: "some title", desc: "some desc"},
          default_key: :title,
          update: %{title: "some updated title", desc: "some updated desc"}
        },
        plural: "posts",
        prefix: nil,
        redacts: [],
        repo: ElixirScribe.Repo,
        repo_alias: "",
        route_helper: "blog_post",
        route_prefix: "/blog/posts",
        sample_id: "11111111-1111-1111-1111-111111111111",
        self: ElixirScribe.Generator.Schema.SchemaContract,
        singular: "post",
        string_attr: :title,
        table: "posts",
        timestamp_type: :naive_datetime,
        types: %{title: :string, desc: :string},
        uniques: [],
        web_namespace: "Blog",
        web_path: "blog"
      },
      self: ElixirScribe.Generator.Domain.DomainContract,
      test_domain_dir: "test/elixir_scribe/domain/blog",
      test_file: "test/elixir_scribe/domain/blog_test.exs",
      test_fixtures_file: "test/support/fixtures/domain/blog/post_fixtures.ex",
      test_resource_dir: "test/elixir_scribe/domain/blog/post",
      test_resource_dir_plural: "test/elixir_scribe/domain/blog/posts",
      test_web_domain_dir: "test/elixir_scribe_web/domain/blog",
      test_web_resource_dir: "test/elixir_scribe_web/domain/blog/post",
      test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/posts",
      web_domain_module: ElixirScribeWeb.Blog,
      web_module: ElixirScribeWeb,
      web_resource_module: ElixirScribeWeb.Blog.Post,
      web_resource_module_plural: ElixirScribeWeb.Blog.Posts
    }

    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

    opts = Keyword.put(opts, :web, "Blog")

    assert domain_contract = %DomainContract{} = DomainContract.new!(valid_args, opts)

    assert expected_domain_contract === domain_contract
  end
end
