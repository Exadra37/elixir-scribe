defmodule ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResourceTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.DomainResourceAPI

  test "returns a list of all resource action files paths" do
    expected_files = [
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/list_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/list/list_posts.ex", "list"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/new_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/new/new_post.ex", "new"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/read_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/read/read_post.ex", "read"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/edit_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/edit/edit_post.ex", "edit"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/create_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/create/create_post.ex", "create"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/update_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/update/update_post.ex", "update"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/delete_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/delete/delete_post.ex", "delete"}
    ]

    contract = domain_contract_fixture()

    assert DomainResourceAPI.build_action_files_paths(contract) === expected_files
  end
end
