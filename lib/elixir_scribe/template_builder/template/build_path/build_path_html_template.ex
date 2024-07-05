defmodule ElixirScribe.TemplateBuilder.Template.BuildPath.BuildPathHtmlTemplate do
  @moduledoc false

  alias Mix.Scribe.Context

  @doc false
  def build(%Context{} = context) do
    template = Keyword.get(context.opts, :template, "default")

    ElixirScribe.html_template_path()
    |> Path.join(template)
  end
end
