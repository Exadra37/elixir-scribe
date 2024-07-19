defmodule ElixirScribe.Mix.Arg.ParseAll.ParseAllArgs do
  @moduledoc false

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
    live: :boolean,
    actions: :string,
    no_default_actions: :boolean
  ]

  def parse(args) when is_list(args) do
    {opts, parsed_args, invalid_args} =
      args
      |> MixAPI.maybe_add_binary_id_option()
      |> extract_args_and_opts()

    opts = opts |> MixAPI.parse_all_options()

    {parsed_args, opts, invalid_args}
  end

  defp extract_args_and_opts(args) do
    OptionParser.parse(args, switches: @switches)
  end
end
