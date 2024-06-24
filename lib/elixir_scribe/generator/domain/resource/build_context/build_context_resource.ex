defmodule ElixirScribe.Generator.Domain.Resource.BuildContext.BuildContextResource do
  @moduledoc false

  alias Mix.Scribe.{Context, Schema}

  @doc false
  def build!(args, opts, _help) when is_list(args) and is_list(opts) do
    [context_name, schema_name, plural | schema_args] = args

    opts = Keyword.put(opts, :web, context_name)

    schema_module = context_name |> Module.concat(schema_name)  |> inspect()

    schema = Schema.new!(schema_module, plural, schema_args, opts)

    Context.new!(context_name, schema, opts)
  end
end
