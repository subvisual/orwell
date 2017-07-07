defmodule Orwell.GitHub.Trees do
  @moduledoc """
  A wrapper to `Tentacat.Trees` using our own `Config`
  """

  alias Orwell.GitHub.Config
  alias Tentacat.Trees

  @spec find_recursive(binary, Config.t) :: Tentacat.response
  def find_recursive(ref, config) do
    Trees.find_recursive(config.owner, config.repo, ref, config.client)
  end
end
