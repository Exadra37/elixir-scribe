defmodule ElixirScribe.Generator.SchemaResourceAPI do
  @moduledoc false

  alias ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract

  def build_schema_resource_contract(args, opts) when is_list(args) and is_list(opts),
    do: BuildSchemaResourceContract.build(args, opts)

  def build_schema_resource_contract!(args, opts) when is_list(args) and is_list(opts),
    do: BuildSchemaResourceContract.build!(args, opts)
end
