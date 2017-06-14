defmodule Orwell.GitHub.Pulls do
  @moduledoc """
  A wrapper to `Tentacat.Pulls` using our own `Config`
  """

  alias Tentacat.Pulls

  import Orwell.GitHub.Config

  @spec create(list | map) :: Tentacat.response
  def create(body) do
    Pulls.create(owner(), repo(), body, client())
  end
end
