
  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= schema.human_singular %>API.<%= action %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def <%= action %>(), do: <%= module_action_name %>.<%= action_first_word %>()
