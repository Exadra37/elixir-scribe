defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect context.web_module %>, :controller

  alias <%= inspect schema.module %>API

  plug :put_view, html: <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>HTML

  def <%= action %>(conn, %{"id" => id}) do
    {:ok, _<%= schema.singular %>} = <%= schema.human_singular %>API.<%= action %>(id)

    conn
    |> put_flash(:info, "<%= schema.human_singular %> deleted successfully.")
    |> redirect(to: ~p"<%= schema.route_prefix %>")
  end
end
