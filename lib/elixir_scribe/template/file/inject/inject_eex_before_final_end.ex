defmodule ElixirScribe.Template.File.Inject.InjectEexBeforeFinalEnd do
  @moduledoc false

  @doc false
  # def inject(content_to_inject, file_path, binding) do
  def inject(base_template_paths, source_path, target_path, binding) do
    content_to_inject =
      base_template_paths
      |> Mix.Phoenix.eval_from(source_path, binding)

    target_file_content = File.read!(target_path)

    if String.contains?(target_file_content, content_to_inject) do
      {:noop, :content_already_exists}
    else
      Mix.shell().info([:green, "* injecting ", :reset, Path.relative_to_cwd(target_path)])

      target_file_content
      |> String.trim_trailing()
      |> String.trim_trailing("end")
      |> EEx.eval_string(binding)
      |> Kernel.<>(content_to_inject)
      |> Kernel.<>("end\n")
      |> write_file(target_path)
    end
  end

  defp write_file(content, file_path) do
    File.write!(file_path, content)
  end
end
