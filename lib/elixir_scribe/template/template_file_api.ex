defmodule ElixirScribe.TemplateFileAPI do
  @moduledoc false

  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.File.Conflicts.MixPromptFileConflicts
  alias ElixirScribe.Template.File.Copy.CopyFile
  alias ElixirScribe.Template.File.Inject.InjectContentBeforeFinalEnd
  alias ElixirScribe.Template.File.Inject.InjectEexBeforeFinalEnd
  alias ElixirScribe.Template.File.BuildFilenameForAction.BuildFilenameForActionFile
  alias ElixirScribe.Template.File.BuildPathForHtml.BuildPathForHtmlFile

  def build_template_action_filename(%BuildFilenameForActionFileContract{} = contract),
    do: BuildFilenameForActionFile.build(contract)

  @doc """
  Prompts to continue if any files exist.
  """
  def prompt_for_conflicts(files) when is_list(files), do: MixPromptFileConflicts.prompt(files)

  @doc """
  Copies files from source dir to target dir according to the given map.

  Files are evaluated against EEx according to the given binding.
  """
  def copy_from(apps, source_dir, binding, mapping) when is_list(mapping),
    do: CopyFile.copy_from(apps, source_dir, binding, mapping)

  def inject_content_before_final_end(content_to_inject, file_path),
    do: InjectContentBeforeFinalEnd.inject(content_to_inject, file_path)

  def inject_eex_before_final_end(content_to_inject, file_path, binding),
    do: InjectEexBeforeFinalEnd.inject(content_to_inject, file_path, binding)

  def build_path_for_html_file(%DomainContract{} = contract), do: BuildPathForHtmlFile.build(contract)
end
