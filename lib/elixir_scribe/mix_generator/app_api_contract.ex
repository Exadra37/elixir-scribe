defmodule ElixirScribe.MixGenerator.AppAPIContract do
  @moduledoc false

  import Norm
  alias Mix.Scribe.Context

  defmodule BuildResourceActionFilePathContract do
    @moduledoc false

    @keys %{
      required: [:action, :context, :file_extension, :path_type],
      optional: [file_type_prefix: "_", file_type: ""]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec(), do: schema(%__MODULE__{
        action: is_binary() |> spec(),
        context: context?() |> spec(),
        file_extension: app_file_extension?() |> spec(),
        file_type_prefix: is_binary() |> spec(),
        file_type: app_file_type?() |> spec(),
        path_type: app_path_type?() |> spec(),
      })

    defp context?(%Context{}), do: true
    defp context?(_context), do: false

    # @resource_actions ElixirScribe.resource_actions()
    # defp resource_action?(action) when action in @resource_actions, do: true
    # defp resource_action?(_action), do: false

    @app_file_extensions ElixirScribe.app_file_extensions()
    defp app_file_extension?(path_type) when path_type in @app_file_extensions, do: true
    defp app_file_extension?(_action), do: false

    @app_file_types ElixirScribe.app_file_types()
    defp app_file_type?(path_type) when path_type in @app_file_types, do: true
    defp app_file_type?(_action), do: false

    @app_path_types ElixirScribe.app_path_types()
    defp app_path_type?(path_type) when path_type in @app_path_types, do: true
    defp app_path_type?(_action), do: false
  end

  defmodule BuildDomainPathContract do
    @moduledoc false

    @keys %{
      required: [:app_lib_dir, :path_type]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec(), do: schema(%__MODULE__{
        app_lib_dir: is_binary() |> spec(),
        path_type: app_path_type?() |> spec(),
      })

    @app_path_types ElixirScribe.app_path_types()
    defp app_path_type?(path_type) when path_type in @app_path_types, do: true
    defp app_path_type?(_action), do: false
  end

  defmodule BuildResourcePathContract do
    @moduledoc false

    alias ElixirScribe.MixGenerator.AppAPIContract.BuildDomainPathContract

    @keys %{
      required: [:domain_contract, :singular_name]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec(), do: schema(%__MODULE__{
        domain_contract: domain_contract?() |> spec(),
        singular_name: not_empty_string?() |> spec(),
      })

    def new(%{domain: domain} = attrs) do
      {:ok, domain_contract} = BuildDomainPathContract.new(domain)

      attrs
      |> Map.put(:domain_contract, domain_contract)
      |> Map.delete(:domain)
      |> super()
    end

    def new(attrs), do: super(attrs)

    def new!(%{domain: domain} = attrs) do
      domain_contract = BuildDomainPathContract.new!(domain)

      attrs
      |> Map.put(:domain_contract, domain_contract)
      |> Map.delete(:domain)
      |> super()
    end

    def new!(attrs), do: super(attrs)

    # @app_path_types ElixirScribe.app_path_types()
    defp domain_contract?(%BuildDomainPathContract{} = contract), do: contract.self.conforms?(contract)
    defp domain_contract?(_domain_contract), do: false

    defp not_empty_string?(nil), do: false
    defp not_empty_string?(resource) when is_binary(resource) do
      resource |> String.trim() |> String.length() > 0
    end
  end
end
