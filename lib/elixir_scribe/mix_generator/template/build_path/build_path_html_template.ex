defmodule ElixirScribe.MixGenerator.Template.BuildPath.BuildPathHtmlTemplate do
  @moduledoc false

  alias Mix.Phoenix.Context

  @doc false
  def build(%Context{} = context) do
    template = Keyword.get(context.opts, :template, "default")

    ElixirScribe.html_template_path()
    |> Path.join(template)
  end
end
