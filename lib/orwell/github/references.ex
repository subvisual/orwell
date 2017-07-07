defmodule Orwell.GitHub.References do
  @moduledoc """
  A wrapper to `Tentacat.References` using our own `Config`
  """

  alias Orwell.GitHub.Config
  alias Tentacat.References

  @spec find(binary, Config.t) :: Tentacat.response
  def find(ref, config) do
    References.find(config.owner, config.repo, ref, config.client)
  end

  @spec create(list | map, Config.t) :: Tentacat.response
  def create(body, config) do
    References.create(config.owner, config.repo, body, config.client)
  end
end
