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

  @spec list(Config.t) :: Tentacat.response
  def list(config) do
    Pulls.list(config.owner, config.repo, config.client)
  end
end
