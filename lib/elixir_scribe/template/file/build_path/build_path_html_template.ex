defmodule ElixirScribe.Template.File.BuildPath.BuildPathHtmlTemplate do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract

  @doc false
  def build(%DomainContract{} = context) do
    template = Keyword.get(context.opts, :template, "default")

    ElixirScribe.html_template_path()
    |> Path.join(template)
  end
end
