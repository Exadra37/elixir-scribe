
  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= schema.human_singular %>API.<%= action %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def <%= action %>(), do: <%= action_capitalized %><%= schema.human_plural %>.<%= action_first_word %>()
