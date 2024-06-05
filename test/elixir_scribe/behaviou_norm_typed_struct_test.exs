defmodule ElixirScribe.Behaviour.NormTypedStructTest do
  use ExUnit.Case
  Code.require_file "test/support/behaviours/person.ex"
  doctest ElixirScribe.Behaviour.NormTypedStruct, except: [:moduledoc, type_spec: 1]
end
