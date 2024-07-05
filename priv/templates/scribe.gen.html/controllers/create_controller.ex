defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect context.web_module %>, :controller

  alias <%= inspect schema.module %>API

  plug :put_view, html: <%= inspect context.web_module %>.<%= schema.web_namespace %>.<%= inspect schema.alias %>HTML

  def <%= action %>(conn, %{<%= inspect schema.singular %> => <%= schema.singular %>_params}) do
    case <%= schema.human_singular %>API.<%= action %>(<%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        conn
        |> put_flash(:info, "<%= schema.human_singular %> created successfully.")
        |> redirect(to: ~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "<%= new_action %>_<%= schema.singular %>.html", changeset: changeset)
    end
  end
end
