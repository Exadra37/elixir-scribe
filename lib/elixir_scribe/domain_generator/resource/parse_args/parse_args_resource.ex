defmodule ElixirScribe.DomainGenerator.Resource.ParseArgs.ParseArgsResource do
  @moduledoc false

  alias Mix.Scribe.{Context, Schema}
  alias ElixirScribe.MixGeneratorAPI

  @switches [
    binary_id: :boolean,
    table: :string,
    web: :string,
    schema: :boolean,
    context: :boolean,
    context_app: :string,
    merge_with_existing_context: :boolean,
    prefix: :string,
    live: :boolean
  ]

  @default_opts [schema: true, context: true, no_default_actions: false, actions: nil]

  @doc false
  def parse(args) when is_list(args) do
    {opts, parsed_args, invalid_args} =
      args
      |> MixGeneratorAPI.maybe_add_binary_id_option()
      |> parse_opts()

    valid_args = parsed_args |> validate_args!(__MODULE__)

    {valid_args, opts, invalid_args}
  end

  defp validate_args!([context, schema, _plural | _] = args, help) do
    cond do
      not Context.valid?(context) ->
        help.raise_with_help(
          "Expected the domain, #{inspect(context)}, to be a valid module name"
        )

      not Schema.valid?(schema) ->
        help.raise_with_help("Expected the schema, #{inspect(schema)}, to be a valid module name")

      context == schema ->
        help.raise_with_help("The domain and schema should have different names")

      context == Mix.Phoenix.base() ->
        help.raise_with_help(
          "Cannot generate domain #{context} because it has the same name as the application"
        )

      schema == Mix.Phoenix.base() ->
        help.raise_with_help(
          "Cannot generate schema #{schema} because it has the same name as the application"
        )

      true ->
        args
    end
  end

  defp validate_args!(_, help) do
    help.raise_with_help("Invalid arguments")
  end

  @doc false
  def raise_with_help(msg) do
    Mix.raise("""
    #{msg}

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
    """)
  end

  defp parse_opts(args) do
    {opts, parsed, invalid} = OptionParser.parse(args, switches: @switches)

    merged_opts =
      @default_opts
      |> Keyword.merge(opts)
      |> put_context_app(opts[:context_app])
      |> put_resource_actions()

    {merged_opts, parsed, invalid}
  end

  defp put_context_app(opts, nil), do: opts

  defp put_context_app(opts, string) do
    Keyword.put(opts, :context_app, String.to_atom(string))
  end

  defp put_resource_actions(opts) do
    resource_actions = MixGeneratorAPI.build_actions_from_options(opts)
    Keyword.put(opts, :resource_actions, resource_actions)
  end
end
