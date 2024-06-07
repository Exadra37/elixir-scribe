defmodule <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>.<%= action_capitalized %>.<%= action_capitalized %><%= inspect schema.alias %>Controller do
  use <%= inspect context.web_module %>, :controller

  alias <%= inspect schema.module %>API

  plug :put_view, html: <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>HTML

  def <%= action %>(conn, %{"id" => id}) do
    <%= schema.singular %> = <%= schema.human_singular %>API.<%= action %>!(id)
    render(conn, "<%= action %>_<%= schema.singular %>.html", <%= schema.singular %>: <%= schema.singular %>)
  end
end
