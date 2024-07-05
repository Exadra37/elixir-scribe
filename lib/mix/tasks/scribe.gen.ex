defmodule Mix.Tasks.Scribe.Gen do
  use Mix.Task

  @shortdoc "Lists all available Scribe generators"

  @moduledoc """
  Lists all available Scribe generators:

  ```console
  mix scribe.gen
  ```
  """

  @doc false
  def run(_args) do
    Mix.Task.run("help", ["--search", "scribe.gen."])
  end
end
