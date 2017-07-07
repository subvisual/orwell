defmodule Orwell.GitHub.Pulls do
  @moduledoc """
  A wrapper to `Tentacat.Pulls` using our own `Config`
  """

  alias Orwell.GitHub.Config
  alias Tentacat.Pulls

  @spec create(list | map, Config.t) :: Tentacat.response
  def create(body, config) do
    Pulls.create(config.owner, config.repo, body, config.client)
  end
end
