defmodule ElixirScribe.Template.File.Inject.InjectEExTemplateBeforeModuleEnd do
  @moduledoc false
  alias ElixirScribe.TemplateFileAPI

  def inject(base_template_paths, source_path, target_path, binding) do
    base_template_paths
    |> Mix.Phoenix.eval_from(source_path, binding)
    |> TemplateFileAPI.inject_content_before_final_end(target_path)
  end
end
