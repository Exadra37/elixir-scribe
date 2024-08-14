
  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> <%=inspect schema.alias %>API.<%= action %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def <%= action %>(), do: <%= module_action_name %>.<%= action_first_word %>()
