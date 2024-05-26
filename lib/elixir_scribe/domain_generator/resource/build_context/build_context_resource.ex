defmodule ElixirScribe.DomainGenerator.Resource.BuildContext.BuildContextResource do
  @moduledoc false

  alias Mix.Phoenix.Context
  alias Mix.Tasks.Phx.Gen

  @doc false
  def build!(args, opts, help) when is_list(args) and is_list(opts) do
    [context_name, schema_name, plural | schema_args] = args

    opts = Keyword.put(opts, :web, context_name)

    schema_module = inspect(Module.concat(context_name, schema_name))

    # @TODO Build the Schema without the help variable and without calling the generator directly
    schema = Gen.Schema.build([schema_module, plural | schema_args], opts, help)

    Context.new(context_name, schema, opts)
  end
end
