defmodule ElixirScribe.DomainGenerator.Resource.PromptForConflicts.PromptForConflictsResource do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.DomainGenerator.ResourceAPI

  @doc false
  def prompt(%Context{} = context) do
    context
    |> ResourceAPI.files_to_generate()
    |> mix_prompt()

    context
  end

  # The function `prompt/1` was copied from the Phoenix Framework module at `/lib/mix/phoenix.ex`.
  # It was modified to use the `action` from the provided `generator_files`,
  # which is now a three elements tuple.

  @doc false
  defp mix_prompt(generator_files) do
    file_paths =
      Enum.flat_map(generator_files, fn
        {:new_eex, _, _path} -> []
        {:new_eex, _, _path, _action} -> []
        {_kind, _, path} -> [path]
        {_kind, _, path, _action} -> [path]
      end)

    case Enum.filter(file_paths, &File.exists?(&1)) do
      [] ->
        :ok

      conflicts ->
        Mix.shell().info("""
        The following files conflict with new files to be generated:

        #{Enum.map_join(conflicts, "\n", &"  * #{&1}")}

        """)

        unless Mix.shell().yes?("Proceed with interactive overwrite?") do
          System.halt()
        end
    end
  end
end
