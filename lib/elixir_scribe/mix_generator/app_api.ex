defmodule ElixirScribe.MixGenerator.AppApi do

  # alias ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilenameContract
  # alias ElixirScribe.MixGenerator.App.BuildResourceActionFilename.BuildResourceActionFilenameApp

  alias ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract
  alias ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathApp

  # def build_resource_action_filename(%BuildResourceActionFilenameContract{} = contract) do
  #   BuildResourceActionFilenameApp.build(contract)
  # end

  def build_resource_action_file_path(%BuildResourceActionFilePathContract{} = contract) do
    BuildResourceActionFilePathApp.build(contract)
  end
end
