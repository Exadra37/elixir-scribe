defmodule ElixirScribe.DomainGenerator.Resource.FilesToGenerate.FilesToGenerateResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.DomainGenerator.ResourceAPI

  @doc false
  test "files_to_generate/1 works as expected" do
    expected_files = [
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/list_schema.ex", "lib/elixir_scribe/domain/site/blog/post/list/list_posts.ex", "list"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/new_schema.ex", "lib/elixir_scribe/domain/site/blog/post/new/new_post.ex", "new"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/read_schema.ex", "lib/elixir_scribe/domain/site/blog/post/read/read_post.ex", "read"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/edit_schema.ex", "lib/elixir_scribe/domain/site/blog/post/edit/edit_post.ex", "edit"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/create_schema.ex", "lib/elixir_scribe/domain/site/blog/post/create/create_post.ex", "create"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/update_schema.ex", "lib/elixir_scribe/domain/site/blog/post/update/update_post.ex", "update"},
      {:eex, "priv/templates/scribe.gen.domain/actions/schema_access/delete_schema.ex", "lib/elixir_scribe/domain/site/blog/post/delete/delete_post.ex", "delete"}
    ]

    context = context_fixture()

    assert ResourceAPI.files_to_generate(context) === expected_files
  end
end
