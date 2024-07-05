defmodule ElixirScribe.MixAPI do
  @moduledoc false

  alias ElixirScribe.TemplateBuilder.Options.BuildActions.BuildActionsFromOptions
  alias ElixirScribe.Mix.Option.ParseAll.ParseAllOptions
  alias ElixirScribe.TemplateBuilder.Options.MaybeAddBinaryId.MaybeAddBinaryIdOption

  def build_actions_from_options(opts) when is_list(opts), do: BuildActionsFromOptions.build(opts)

  def parse_all_options(opts) when is_list(opts), do: ParseAllOptions.parse(opts)

  def maybe_add_binary_id_option(args) when is_list(args),
    do: MaybeAddBinaryIdOption.maybe_add(args)
end
