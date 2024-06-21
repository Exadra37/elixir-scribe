defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect context.web_module %>, :controller

  alias <%= inspect schema.module %>API

  plug :put_view, html: <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>HTML

  def <%= action %>(conn, _params) do
    <%= schema.plural %> = <%= schema.human_singular %>API.<%= action %>()
    render(conn, "<%= action %>_<%= schema.plural %>.html", <%= schema.collection %>: <%= schema.plural %>)
  end
end
