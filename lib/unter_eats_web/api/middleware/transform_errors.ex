defmodule UnterEatsWeb.Api.Middleware.TransformErrors do
  use GraphQLTools.TransformErrors, gettext_module: UnterEatsWeb.Gettext
end
