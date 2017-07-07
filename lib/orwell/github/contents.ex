defmodule Orwell.GitHub.Contents do
  @moduledoc """
  A wrapper to `Tentacat.Contents` using our own `Config`
  """

  alias Orwell.GitHub.Config
  alias Tentacat.Contents

  @spec create(binary, list | map, Config.t) :: Tentacat.response
  def create(path, body, config) do
    Contents.create(config.owner, config.repo, path, body, config.client)
  end

  @spec find(binary, Config.t) :: Tentacat.response
  def find(path, config) do
    Contents.find(config.owner, config.repo, path, config.client)
  end
end
