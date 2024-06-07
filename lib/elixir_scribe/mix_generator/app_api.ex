defmodule ElixirScribe.MixGenerator.AppAPI do
  @moduledoc false

  alias ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract
  alias ElixirScribe.MixGenerator.App.BuildDomainPath.BuildDomainPathApp

  alias ElixirScribe.MixGenerator.AppAPIContract.BuildResourcePathContract
  alias ElixirScribe.MixGenerator.App.BuildResourcePath.BuildResourcePathApp

  alias ElixirScribe.MixGenerator.AppAPIContract.BuildResourceActionFilePathContract
  alias ElixirScribe.MixGenerator.App.BuildResourceActionFilePath.BuildResourceActionFilePathApp

  def build_domain_path(%BuildDomainPathContract{} = contract) do
    BuildDomainPathApp.build(contract)
  end

  def build_resource_path(%BuildResourcePathContract{} = contract) do
    BuildResourcePathApp.build(contract)
  end

  def build_resource_action_file_path(%BuildResourceActionFilePathContract{} = contract) do
    BuildResourceActionFilePathApp.build(contract)
  end
end
