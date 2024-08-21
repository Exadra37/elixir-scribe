defmodule ElixirScribe.TemplateBuilder.Options.BuildEmbedTemplates.BuildModuleEmbedTemplatesTest do
  alias ElixirScribe.TemplateBuilderAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds an build_embeded_templates statement for each HTML resource action" do
    assert TemplateBuilderAPI.build_embeded_templates() == "\n  embed_templates \"read/*\"\n  embed_templates \"new/*\"\n  embed_templates \"edit/*\"\n  embed_templates \"list/*\""
  end
end
