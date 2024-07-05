defmodule ElixirScribe.TemplateBuilder.Options.MaybeAddBinaryId.MaybeAddBinaryIdOption do
  @moduledoc false

  def maybe_add(args) when is_list(args) do
    cond do
      "--no-binary-id" in args -> args
      "--binary-id" in args -> args
      args -> ["--binary-id" | args]
    end
  end
end
