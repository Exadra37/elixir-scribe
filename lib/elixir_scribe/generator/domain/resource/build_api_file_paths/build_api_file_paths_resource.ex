defmodule ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource do
  @moduledoc false

  alias Mix.Scribe.Context

  def build(%Context{generate?: false}), do: []
  def build(%Context{generate?: true} = context), do: build_api_file(context)

  def build_api_file(context) do
    source_path = ElixirScribe.domain_api_template_path() |> Path.join("api_module.ex")
    target_path = context.api_file

    {:eex, :api, source_path, target_path}
  end
end
