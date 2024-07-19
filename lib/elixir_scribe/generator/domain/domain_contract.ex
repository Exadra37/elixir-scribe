defmodule ElixirScribe.Generator.Domain.DomainContract do
  @moduledoc false

  # This module was borrowed from the Phoenix Framework module
  # Mix.Phoenix.Context and modified to suite ElixirScribe needs.

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.Generator.Schema.SchemaContract
  alias ElixirScribe.Utils.StringAPI

  @required [
    :name,
    :module,
    :resource_module,
    :resource_module_plural,
    :schema,
    :alias,
    :base_module,
    :web_module,
    :web_domain_module,
    :web_resource_module,
    :web_resource_module_plural,
    :basename,
    :api_file,
    :test_file,
    :test_fixtures_file,
    :lib_web_domain_dir,
    :lib_domain_dir,
    :lib_web_resource_dir,
    :lib_web_resource_dir_plural,
    :lib_resource_dir,
    :lib_resource_dir_plural,
    :test_web_domain_dir,
    :test_domain_dir,
    :test_web_resource_dir,
    :test_web_resource_dir_plural,
    :test_resource_dir,
    :test_resource_dir_plural,
    :context_app,
    :resource_name_singular,
    :resource_name_plural,
    :resource_actions
  ]

  @optional [
    generate?: true,
    opts: []
  ]

  use ElixirScribe.Behaviour.TypedContract, keys: %{required: @required, optional: @optional}

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      name: is_binary() |> spec(),
      module: is_atom() |> spec(),
      resource_module: is_atom() |> spec(),
      resource_module_plural: is_atom() |> spec(),
      schema: spec(is_struct() or is_nil()),
      alias: is_atom() |> spec(),
      base_module: is_atom() |> spec(),
      web_module: is_atom() |> spec(),
      web_domain_module: is_atom() |> spec(),
      web_resource_module: is_atom() |> spec(),
      web_resource_module_plural: is_atom() |> spec(),
      basename: is_binary() |> spec(),
      api_file: is_binary() |> spec(),
      test_file: is_binary() |> spec(),
      test_fixtures_file: is_binary() |> spec(),
      lib_web_domain_dir: is_binary() |> spec(),
      lib_domain_dir: is_binary() |> spec(),
      lib_web_resource_dir: is_binary() |> spec(),
      lib_web_resource_dir_plural: is_binary() |> spec(),
      lib_resource_dir: is_binary() |> spec(),
      lib_resource_dir_plural: is_binary() |> spec(),
      test_web_domain_dir: is_binary() |> spec(),
      test_domain_dir: is_binary() |> spec(),
      test_web_resource_dir: is_binary() |> spec(),
      test_web_resource_dir_plural: is_binary() |> spec(),
      test_resource_dir: is_binary() |> spec(),
      test_resource_dir_plural: is_binary() |> spec(),
      generate?: is_boolean() |> spec(),
      context_app: is_atom() |> spec(),
      resource_actions: is_list() |> spec(),
      resource_name_singular: is_binary() |> spec(),
      resource_name_plural: is_binary() |> spec(),
      opts: is_list() |> spec()
    })
  end

  def new!(args, opts) when is_list(args) and is_list(opts) do
    case new(args, opts) do
      {:ok, contract} ->
        contract

      {:error, reasons} when is_list(reasons) ->
        raise """
        The contract doesn't conform with the specification:

        #{inspect(reasons)}
        """

      {:error, msg, context} ->
        raise("""
        #{msg}

        #{context}
        """)
    end
  end

  def new(args, opts) when is_list(args) and is_list(opts) do
    with {:ok, args} <- validate_args!(args) do
      [context_name, schema_name, plural | schema_args] = args

      opts = Keyword.put(opts, :web, context_name)

      schema_module = context_name |> Module.concat(schema_name) |> inspect()

      schema = SchemaContract.new!(schema_module, plural, schema_args, opts)

      new(context_name, schema, opts)
    end
  end

  def new(context_name, %SchemaContract{} = schema, opts) do
    resource_name_singular = schema.singular
    resource_name_plural = schema.plural
    resource_name_plural_capitalized = resource_name_plural |> StringAPI.capitalize()

    ctx_app = opts[:context_app] || Mix.Phoenix.context_app()

    base = Module.concat([Mix.Phoenix.context_base(ctx_app)])
    base_web = web_module()

    module = Module.concat(base, context_name)
    resource_module = Module.concat(module, schema.alias)
    resource_module_plural = Module.concat(module, resource_name_plural_capitalized)
    web_domain_module = Module.concat(base_web, context_name)
    web_resource_module = Module.concat([web_domain_module, schema.alias])

    web_resource_module_plural =
      Module.concat([web_domain_module, resource_name_plural_capitalized])

    domain = Module.concat([module |> Module.split() |> List.last()])
    basedir = Path.join(["domain", Phoenix.Naming.underscore(context_name)])
    basename = Path.basename(basedir)

    lib_web_domain_dir = Mix.Phoenix.web_path(ctx_app, basedir)
    test_web_domain_dir = Mix.Phoenix.web_test_path(ctx_app, basedir)
    lib_domain_dir = Mix.Phoenix.context_lib_path(ctx_app, basedir)
    test_domain_dir = Mix.Phoenix.context_test_path(ctx_app, basedir)

    lib_web_resource_dir = Path.join([lib_web_domain_dir, resource_name_singular])
    test_web_resource_dir = Path.join([test_web_domain_dir, resource_name_singular])
    lib_web_resource_dir_plural = Path.join([lib_web_domain_dir, resource_name_plural])
    test_web_resource_dir_plural = Path.join([test_web_domain_dir, resource_name_plural])

    lib_resource_dir = Path.join([lib_domain_dir, resource_name_singular])
    lib_resource_dir_plural = Path.join([lib_domain_dir, resource_name_plural])
    test_resource_dir = Path.join([test_domain_dir, resource_name_singular])
    test_resource_dir_plural = Path.join([test_domain_dir, resource_name_plural])

    test_file = test_domain_dir <> "_test.exs"
    test_fixtures_dir = Mix.Phoenix.context_app_path(ctx_app, "test/support/fixtures")

    test_fixtures_file =
      Path.join([test_fixtures_dir, basedir, resource_name_singular <> "_fixtures.ex"])

    generate? = Keyword.get(opts, :context, true)
    api_file = lib_resource_dir <> "_api.ex"

    %DomainContract{
      name: context_name,
      module: module,
      resource_module: resource_module,
      resource_module_plural: resource_module_plural,
      schema: schema,
      alias: domain,
      base_module: base,
      web_module: base_web,
      web_domain_module: web_domain_module,
      web_resource_module: web_resource_module,
      web_resource_module_plural: web_resource_module_plural,
      basename: basename,
      api_file: api_file,
      test_file: test_file,
      test_fixtures_file: test_fixtures_file,
      lib_web_domain_dir: lib_web_domain_dir,
      lib_domain_dir: lib_domain_dir,
      lib_web_resource_dir: lib_web_resource_dir,
      lib_web_resource_dir_plural: lib_web_resource_dir_plural,
      lib_resource_dir: lib_resource_dir,
      lib_resource_dir_plural: lib_resource_dir_plural,
      test_web_domain_dir: test_web_domain_dir,
      test_domain_dir: test_domain_dir,
      test_web_resource_dir: test_web_resource_dir,
      test_web_resource_dir_plural: test_web_resource_dir_plural,
      test_resource_dir: test_resource_dir,
      test_resource_dir_plural: test_resource_dir_plural,
      generate?: generate?,
      context_app: ctx_app,
      resource_actions: Keyword.get(opts, :resource_actions),
      resource_name_singular: resource_name_singular,
      resource_name_plural: resource_name_plural,
      opts: opts
    }
    |> conforms()
  end

  defp validate_args!([context, schema, _plural | _] = args) do
    cond do
      not valid?(context) ->
        build_error_with_help("Expected the domain, #{inspect(context)}, to be a valid module name")

      not SchemaContract.valid?(schema) ->
        build_error_with_help("Expected the schema, #{inspect(schema)}, to be a valid module name")

      context == schema ->
        build_error_with_help("The domain and schema should have different names")

      context == Mix.Phoenix.base() ->
        build_error_with_help(
          "Cannot generate domain #{context} because it has the same name as the application"
        )

      schema == Mix.Phoenix.base() ->
        build_error_with_help(
          "Cannot generate schema #{schema} because it has the same name as the application"
        )

      true ->
        {:ok, args}
    end
  end

  defp validate_args!(_) do
    build_error_with_help("Invalid arguments")
  end

  @doc false
  def build_error_with_help(msg) do
    context =
      """
      mix scribe.gen.domain expects a domain module name, followed by singular and
      plural names of a resource, ending with any number of attributes that will
      define the database table and schema.

      For example:

      mix scribe.gen.domain Catalog Category categories name:string, desc: string
      mix scribe.gen.domain Catalog Product products name:string, desc: string

      The API boundary for each resource in a domain is located at the root of a
      resource, `MyApp.Catalog.CategoryAPI`.
      A domain is usually composed of multiple resources and all possible actions
      on a resource.
      """

    {:error, msg, context}
  end

  defp valid?(context) do
    context =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  defp web_module do
    base = Mix.Phoenix.base()

    cond do
      Mix.Phoenix.context_app() != Mix.Phoenix.otp_app() ->
        Module.concat([base])

      String.ends_with?(base, "Web") ->
        Module.concat([base])

      true ->
        Module.concat(["#{base}Web"])
    end
  end

  # @TODO: Extract all below public functions (ex Mix.Phoenix.Context), because
  #        they don't make sense to belong to an Elixir Scribe typed contract.



  def pre_existing?(%DomainContract{api_file: file}), do: File.exists?(file)

  def pre_existing_tests?(%DomainContract{test_file: file}), do: File.exists?(file)

  def pre_existing_test_fixtures?(%DomainContract{test_fixtures_file: file}),
    do: File.exists?(file)

  def function_count(%DomainContract{api_file: file}) do
    {_ast, count} =
      file
      |> File.read!()
      |> Code.string_to_quoted!()
      |> Macro.postwalk(0, fn
        {:def, _, _} = node, count -> {node, count + 1}
        {:defdelegate, _, _} = node, count -> {node, count + 1}
        node, count -> {node, count}
      end)

    count
  end

  def file_count(%DomainContract{lib_domain_dir: dir}) do
    dir
    |> Path.join("**/*.ex")
    |> Path.wildcard()
    |> Enum.count()
  end
end
