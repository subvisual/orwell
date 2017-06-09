defmodule Orwell.GitHub.Contents do
  @moduledoc """
  A wrapper to `Tentacat.Contents` using our own `Config`
  """

  alias Tentacat.Contents

  import Orwell.GitHub.Config

  @spec create(binary, list | map) :: Tentacat.response
  def create(path, body) do
    Contents.create(owner(), repo(), path, body, client())
  end
end
