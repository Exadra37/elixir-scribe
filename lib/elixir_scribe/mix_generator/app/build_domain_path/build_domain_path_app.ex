defmodule ElixirScribe.MixGenerator.App.BuildDomainPath.BuildDomainPathApp do
  @moduledoc false

  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract

  def build(%BuildDomainPathContract{} = contract) do
    app_lib_core_path = ElixirScribe.app_path(:lib_core)
    domains_path = contract.app_lib_dir |> String.replace(app_lib_core_path, "")
    app_dir = ElixirScribe.app_path(contract.path_type)

    Path.join([app_dir, "domain", domains_path])
  end
end
