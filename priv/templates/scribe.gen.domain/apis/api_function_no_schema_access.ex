
  @doc """
  <%= schema.human_singular %>: <%= action_human_capitalized %>.
  """
  def <%= action %>(), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>()
