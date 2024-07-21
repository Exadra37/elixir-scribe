defmodule ElixirScribe.Generator.Domain.DomainContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Domain.ResourceAPI

  describe "new!/2 builds the contract successfully" do
    test "with one level Domain" do
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

      # opts = Keyword.put(opts, :web, "Blog")

      assert domain_contract = %DomainContract{} = DomainContract.new!(valid_args, opts)

      expected_fields = Map.keys(expected_domain_contract)
      assert_structs_equal(expected_domain_contract, domain_contract, expected_fields)
    end

    test "with two nested Domains" do
      args = ["Blog.Site", "Post", "posts", "title:string", "desc:string"]

      expected_domain_contract = %DomainContract{
        alias: Site,
        api_file: "lib/elixir_scribe/domain/blog/site/post_api.ex",
        base_module: ElixirScribe,
        basename: "site",
        context_app: :elixir_scribe,
        generate?: true,
        lib_domain_dir: "lib/elixir_scribe/domain/blog/site",
        lib_resource_dir: "lib/elixir_scribe/domain/blog/site/post",
        lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/site/posts",
        lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog/site",
        lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/site/post",
        lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/site/posts",
        module: ElixirScribe.Blog.Site,
        name: "Blog.Site",
        opts: [
          {:web, "Blog.Site"},
          {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
          {:schema, true},
          {:context, true},
          {:no_default_actions, false},
          {:actions, nil},
          {:binary_id, true}
        ],
        resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
        resource_module: ElixirScribe.Blog.Site.Post,
        resource_module_plural: ElixirScribe.Blog.Site.Posts,
        resource_name_plural: "posts",
        resource_name_singular: "post",
        schema: %ElixirScribe.Generator.Schema.SchemaContract{
          alias: Post,
          api_route_prefix: "/api/blog/site/posts",
          assocs: [],
          attrs: [{:title, :string}, {:desc, :string}],
          binary_id: true,
          collection: "posts",
          context_app: :elixir_scribe,
          defaults: %{title: "", desc: ""},
          embedded?: false,
          file: "lib/elixir_scribe/domain/blog/site/post/post_schema.ex",
          fixture_params: [{:desc, "\"some desc\""}, {:title, "\"some title\""}],
          fixture_unique_functions: [],
          generate?: true,
          human_plural: "Posts",
          human_singular: "Post",
          indexes: [],
          migration?: true,
          migration_defaults: %{title: "", desc: ""},
          migration_module: Ecto.Migration,
          module: ElixirScribe.Blog.Site.Post,
          optionals: [],
          opts: [
            {:web, "Blog.Site"},
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
          route_helper: "blog_site_post",
          route_prefix: "/blog/site/posts",
          sample_id: "11111111-1111-1111-1111-111111111111",
          self: ElixirScribe.Generator.Schema.SchemaContract,
          singular: "post",
          string_attr: :title,
          table: "posts",
          timestamp_type: :naive_datetime,
          types: %{title: :string, desc: :string},
          uniques: [],
          web_namespace: "Blog.Site",
          web_path: "blog/site"
        },
        self: ElixirScribe.Generator.Domain.DomainContract,
        test_domain_dir: "test/elixir_scribe/domain/blog/site",
        test_file: "test/elixir_scribe/domain/blog/site_test.exs",
        test_fixtures_file: "test/support/fixtures/domain/blog/site/post_fixtures.ex",
        test_resource_dir: "test/elixir_scribe/domain/blog/site/post",
        test_resource_dir_plural: "test/elixir_scribe/domain/blog/site/posts",
        test_web_domain_dir: "test/elixir_scribe_web/domain/blog/site",
        test_web_resource_dir: "test/elixir_scribe_web/domain/blog/site/post",
        test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/site/posts",
        web_domain_module: ElixirScribeWeb.Blog.Site,
        web_module: ElixirScribeWeb,
        web_resource_module: ElixirScribeWeb.Blog.Site.Post,
        web_resource_module_plural: ElixirScribeWeb.Blog.Site.Posts
      }

      {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

      # opts = Keyword.put(opts, :web, "Blog")

      assert domain_contract = %DomainContract{} = DomainContract.new!(valid_args, opts)

      expected_fields = Map.keys(expected_domain_contract)
      assert_structs_equal(expected_domain_contract, domain_contract, expected_fields)
    end

    test "with three nested Domains" do
      args = ["Blog.Site.Admin", "Post", "posts", "title:string", "desc:string"]

      expected_domain_contract = %DomainContract{
        alias: Admin,
        api_file: "lib/elixir_scribe/domain/blog/site/admin/post_api.ex",
        base_module: ElixirScribe,
        basename: "admin",
        context_app: :elixir_scribe,
        generate?: true,
        lib_domain_dir: "lib/elixir_scribe/domain/blog/site/admin",
        lib_resource_dir: "lib/elixir_scribe/domain/blog/site/admin/post",
        lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/site/admin/posts",
        lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog/site/admin",
        lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/site/admin/post",
        lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/site/admin/posts",
        module: ElixirScribe.Blog.Site.Admin,
        name: "Blog.Site.Admin",
        opts: [
          {:web, "Blog.Site.Admin"},
          {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
          {:schema, true},
          {:context, true},
          {:no_default_actions, false},
          {:actions, nil},
          {:binary_id, true}
        ],
        resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
        resource_module: ElixirScribe.Blog.Site.Admin.Post,
        resource_module_plural: ElixirScribe.Blog.Site.Admin.Posts,
        resource_name_plural: "posts",
        resource_name_singular: "post",
        schema: %ElixirScribe.Generator.Schema.SchemaContract{
          alias: Post,
          api_route_prefix: "/api/blog/site/admin/posts",
          assocs: [],
          attrs: [{:title, :string}, {:desc, :string}],
          binary_id: true,
          collection: "posts",
          context_app: :elixir_scribe,
          defaults: %{title: "", desc: ""},
          embedded?: false,
          file: "lib/elixir_scribe/domain/blog/site/admin/post/post_schema.ex",
          fixture_params: [{:desc, "\"some desc\""}, {:title, "\"some title\""}],
          fixture_unique_functions: [],
          generate?: true,
          human_plural: "Posts",
          human_singular: "Post",
          indexes: [],
          migration?: true,
          migration_defaults: %{title: "", desc: ""},
          migration_module: Ecto.Migration,
          module: ElixirScribe.Blog.Site.Admin.Post,
          optionals: [],
          opts: [
            {:web, "Blog.Site.Admin"},
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
          route_helper: "blog_site_admin_post",
          route_prefix: "/blog/site/admin/posts",
          sample_id: "11111111-1111-1111-1111-111111111111",
          self: ElixirScribe.Generator.Schema.SchemaContract,
          singular: "post",
          string_attr: :title,
          table: "posts",
          timestamp_type: :naive_datetime,
          types: %{title: :string, desc: :string},
          uniques: [],
          web_namespace: "Blog.Site.Admin",
          web_path: "blog/site/admin"
        },
        self: ElixirScribe.Generator.Domain.DomainContract,
        test_domain_dir: "test/elixir_scribe/domain/blog/site/admin",
        test_file: "test/elixir_scribe/domain/blog/site/admin_test.exs",
        test_fixtures_file: "test/support/fixtures/domain/blog/site/admin/post_fixtures.ex",
        test_resource_dir: "test/elixir_scribe/domain/blog/site/admin/post",
        test_resource_dir_plural: "test/elixir_scribe/domain/blog/site/admin/posts",
        test_web_domain_dir: "test/elixir_scribe_web/domain/blog/site/admin",
        test_web_resource_dir: "test/elixir_scribe_web/domain/blog/site/admin/post",
        test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/site/admin/posts",
        web_domain_module: ElixirScribeWeb.Blog.Site.Admin,
        web_module: ElixirScribeWeb,
        web_resource_module: ElixirScribeWeb.Blog.Site.Admin.Post,
        web_resource_module_plural: ElixirScribeWeb.Blog.Site.Admin.Posts
      }

      {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args()

      # opts = Keyword.put(opts, :web, "Blog")

      assert domain_contract = %DomainContract{} = DomainContract.new!(valid_args, opts)

      expected_fields = Map.keys(expected_domain_contract)
      assert_structs_equal(expected_domain_contract, domain_contract, expected_fields)
    end
  end

  describe "new!/2 doesn't build the contract" do
    test "when is missing required args" do

      valid_args = ["Blog.Site.Admin", "Post"]
      opts = []

      assert_raise RuntimeError, ~r/^Invalid arguments.*$/s, fn -> DomainContract.new!(valid_args, opts) end

    end

    test "when --no-default-actions option is true and no --actions are given" do

      valid_args = ["Blog.Site.Admin", "Post", "posts", "name:string"]

      opts = [
        resource_actions: [],
        schema: true,
        context: true,
        no_default_actions: true,
        actions: nil,
        binary_id: true
      ]

      contract =  %DomainContract{} = DomainContract.new!(valid_args, opts)

      message = "no match of right hand side value: [\"Blog.Site.Admin\", \"Post\"]"

      # assert_raise MatchError, message, fn -> DomainContract.new!(valid_args, opts) end
    dbg(contract)
    end
  end
end
