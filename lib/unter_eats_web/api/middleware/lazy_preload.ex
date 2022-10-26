defmodule UnterEatsWeb.Api.Middleware.LazyPreload do
  use GraphQLTools.LazyPreload, repo: UnterEats.Repo
end
