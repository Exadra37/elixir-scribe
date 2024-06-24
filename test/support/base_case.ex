defmodule ElixirScribe.BaseCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import ElixirScribe.Generator.DomainFixtures
    end
  end
end
