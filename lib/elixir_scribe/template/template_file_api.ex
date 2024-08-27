defmodule ElixirScribe.TemplateFileAPI do
  @moduledoc false

  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.File.Inject.InjectContentBeforeFinalEnd
  alias ElixirScribe.Template.File.Inject.InjectEexBeforeFinalEnd
  alias ElixirScribe.Template.File.BuildFilenameForAction.BuildFilenameForActionFile
  alias ElixirScribe.Template.File.BuildPathForHtml.BuildPathForHtmlFile

  def build_dir_path_for_html_file(%DomainContract{} = contract),
    do: BuildPathForHtmlFile.build(contract)

  def build_template_action_filename(%BuildFilenameForActionFileContract{} = contract),
    do: BuildFilenameForActionFile.build(contract)

  def inject_content_before_final_end(content_to_inject, file_path),
    do: InjectContentBeforeFinalEnd.inject(content_to_inject, file_path)

  def inject_eex_before_final_end(content_to_inject, file_path, binding),
    do: InjectEexBeforeFinalEnd.inject(content_to_inject, file_path, binding)
end
