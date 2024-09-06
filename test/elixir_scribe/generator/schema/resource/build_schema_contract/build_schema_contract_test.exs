defmodule ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContractTest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.SchemaContract
  alias ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract

  use ElixirScribe.BaseCase, async: true

  describe "doesn't build the Schema contract" do
    test "when is missing some the schema table name for the resource" do
      args = ["Blog.Site.Admin", "Post"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Missing the schema table name for the resource. Needs to be lowercase and in the plural form.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when is missing some the resource name and schema table name" do
      args = ["Blog.Site.Admin"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Missing the resource name and schema table name. Resource name needs to capitalized and the schema name needs to be lowercase and in the plural form.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when is missing all the required args" do
      args = []
      opts = []

      assert_raise RuntimeError, ~r/^No arguments were provided.*$/s, fn ->
        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when the Domain isn't a valid module name" do
      args = ["Blog.Site.admin", "Post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Domain, \"Blog.Site.admin\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource isn't a valid module name" do
      args = ["Blog.Admin", "post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Resource, \"post\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Domain and Resource have the same name" do
      args = ["Blog", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^The Domain and Resource should have different name.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the Domain and the Application have the same name" do
      args = ["ElixirScribe", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Domain ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource and the Application have the same name" do
      args = ["Blog", "ElixirScribe", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Resource ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the table name missing from references" do
      assert_raise Mix.Error, ~r/expect the table to be given to user_id:references/, fn ->
        args = ["Blog", "Post", "posts", "user_id:references"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when the type missing from array" do
      assert_raise Mix.Error,
                   ~r/expect the type of the array to be given to settings:array/,
                   fn ->
                     args = ["Blog", "Post", "posts", "settings:array"]
                     opts = []

                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when a schema field definition is used in place of the schema table name" do
      assert_raise RuntimeError,
                   ~r/Expected the schema plural argument, \"title:string\", to be all lowercase using snake_case convention.*/,
                   fn ->
                     args = ["Blog", "Post", "title:string"]
                     opts = []

                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the schema plural has uppercased characters or camelized format" do
      assert_raise RuntimeError, fn ->
        args = ["Blog", "Post", "Posts", "title:string"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end

      assert_raise RuntimeError, fn ->
        args = ["Blog", "Post", "BlogPosts", "title:string"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end
    end
  end

  describe "builds the Schema contract" do
    test "only with required arguments" do
      expected_contract = %{
        route_prefix: "/blog/posts",
        human_singular: "Post",
        web_path: "blog",
        params: %{update: %{}, create: %{}, default_key: :some_field},
        prefix: nil,
        migration?: true,
        sample_id: "11111111-1111-1111-1111-111111111111",
        repo: ElixirScribe.Repo,
        fixture_params: [],
        embedded?: false,
        collection: "posts",
        module: ElixirScribe.Blog.Post,
        uniques: [],
        defaults: %{},
        indexes: [],
        fixture_unique_functions: [],
        redacts: [],
        migration_module: Ecto.Migration,
        alias: Post,
        types: %{},
        self: ElixirScribe.Generator.SchemaContract,
        human_plural: "Posts",
        context_app: :elixir_scribe,
        attrs: [],
        string_attr: nil,
        optionals: [],
        web_namespace: "Blog",
        api_route_prefix: "/api/blog/posts",
        route_helper: "blog_post",
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        generate?: true,
        timestamp_type: :naive_datetime,
        binary_id: true,
        table: "posts",
        singular: "post",
        plural: "posts",
        repo_alias: "",
        assocs: [],
        migration_defaults: %{}
      }

      args = ~w(Blog Post posts)

      assert_schema_contract(args, expected_contract)
    end

    test "with required and optional arguments" do
      expected_contract = %{
        route_prefix: "/blog/posts",
        human_singular: "Post",
        web_path: "blog",
        params: %{
          update: %{title: "some updated title"},
          create: %{title: "some title"},
          default_key: :title
        },
        prefix: nil,
        migration?: true,
        sample_id: "11111111-1111-1111-1111-111111111111",
        repo: ElixirScribe.Repo,
        fixture_params: [title: "\"some title\""],
        embedded?: false,
        collection: "posts",
        module: ElixirScribe.Blog.Post,
        uniques: [],
        defaults: %{title: ""},
        indexes: [],
        fixture_unique_functions: [],
        redacts: [],
        migration_module: Ecto.Migration,
        alias: Post,
        types: %{title: :string},
        self: ElixirScribe.Generator.SchemaContract,
        human_plural: "Posts",
        context_app: :elixir_scribe,
        attrs: [title: :string],
        string_attr: :title,
        optionals: [],
        web_namespace: "Blog",
        api_route_prefix: "/api/blog/posts",
        route_helper: "blog_post",
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        generate?: true,
        timestamp_type: :naive_datetime,
        binary_id: true,
        table: "posts",
        singular: "post",
        plural: "posts",
        repo_alias: "",
        assocs: [],
        migration_defaults: %{title: ""}
      }

      args = ~w(Blog Post posts title:string)

      assert_schema_contract(args, expected_contract)
    end
  end

  describe ":repo option" do
    test "sets a custom repo module" do
      args = ~w(Blog.Post Post posts title:string --repo MyApp.CustomRepo)
      assert_schema_contract(args, %{repo: ElixirScribe.Repo})
    end
  end

  defp assert_schema_contract(args, expected_contract) do
    expected_keys = Map.keys(expected_contract)

    # expected_opts = []

    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()
dbg(opts)
    assert {:ok, schema_contract = %SchemaContract{}} =
             BuildSchemaResourceContract.build(valid_args, opts)

    assert ^schema_contract =
             %SchemaContract{} = BuildSchemaResourceContract.build!(valid_args, opts)

    contract = Map.from_struct(schema_contract)
    {_opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    # assert_lists_equal(expected_opts, opts)
  end
end
