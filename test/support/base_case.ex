defmodule ElixirScribe.BaseCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import ElixirScribe.DomainGeneratorFixtures
    end
  end
end
