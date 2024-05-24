
  @doc """
  Returns an `%Ecto.Changeset{}` with a default `%<%=  context.schema.human_singular %>{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> <%= action %>_<%= schema.singular %>()
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{}}

  """
  def <%= action %>_<%= schema.singular %>(), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>()
