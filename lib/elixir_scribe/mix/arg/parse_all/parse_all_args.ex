defmodule ElixirScribe.Mix.Arg.ParseAll.ParseAllArgs do
  @moduledoc false

  alias ElixirScribe.Generator.{DomainContract, SchemaContract}
  alias ElixirScribe.MixAPI

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

  def parse(args) when is_list(args) do
    {opts, parsed_args, invalid_args} =
      args
      |> MixAPI.maybe_add_binary_id_option()
      |> extract_args_and_opts()

    opts = opts |> MixAPI.parse_all_options()

    valid_args = parsed_args |> validate_args!(__MODULE__)

    {valid_args, opts, invalid_args}
  end

  defp extract_args_and_opts(args) do
    OptionParser.parse(args, switches: @switches)
  end

  defp validate_args!([context, schema, _plural | _] = args, help) do
    cond do
      not DomainContract.valid?(context) ->
        help.raise_with_help(
          "Expected the domain, #{inspect(context)}, to be a valid module name"
        )

      not SchemaContract.valid?(schema) ->
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
end
