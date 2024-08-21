defmodule ElixirScribe.MixAPI do
  @moduledoc false

  alias ElixirScribe.Mix.CLICommand.Parse.ParseCLICommand
  # alias ElixirScribe.TemplateBuilder.Options.BuildActions.BuildActionsFromOptions
  # alias ElixirScribe.TemplateBuilder.Options.MaybeAddBinaryId.MaybeAddBinaryIdOption

  @d
  Parses the provided list, that represents the CLI command, into one list of arguments and one list of options. The returned options will include all the options with their defaults.

  It returns a tuple in this format: `{parsed_args, all_opts, invalid}`.
  """
  def parse_cli_command(args) when is_list(args), do: ParseCLICommand.parse(args)

  # def build_actions_from_options(opts) when is_list(opts), do: BuildActionsFromOptions.build(opts)

  # def maybe_add_binary_id_option(args) when is_list(args),
  #   do: MaybeAddBinaryIdOption.maybe_add(args)
end
