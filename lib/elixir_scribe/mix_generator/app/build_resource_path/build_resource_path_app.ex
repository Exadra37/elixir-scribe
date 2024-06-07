defmodule ElixirScribe.MixGenerator.App.BuildResourcePath.BuildResourcePathApp do
  @moduledoc false

  alias  ElixirScribe.MixGenerator.AppAPIContract.BuildResourcePathContract

  def build_app_resource_path(%BuildResourcePathContract{} = contract) do
    domains_path = ElixirScribe.MixGenerator.AppAPI.build_domain_path(contract.domain_contract)

    Path.join([domains_path, contract.singular_name])
  end
end
