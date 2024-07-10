defmodule ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract

  def build(%DomainContract{generate?: false}), do: []
  def build(%DomainContract{generate?: true} = context), do: build_api_file(context)

  def build_api_file(context) do
    source_path = ElixirScribe.domain_api_template_path() |> Path.join("api_module.ex")
    target_path = context.api_file

    {:eex, :api, source_path, target_path}
  end
end
