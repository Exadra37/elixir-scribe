defmodule ElixirScribe.Generator.Domain.Resource.BuildContext.BuildContextResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract

  @doc false
  def build!(args, opts) when is_list(args) and is_list(opts) do
    # [context_name, schema_name, plural | schema_args] = args

    # opts = Keyword.put(opts, :web, context_name)

    # schema_module = context_name |> Module.concat(schema_name)  |> inspect()

    # schema = SchemaContract.new!(schema_module, plural, schema_args, opts)

    # DomainContract.new!(context_name, schema, opts)
    DomainContract.new!(args, opts)
  end
end
