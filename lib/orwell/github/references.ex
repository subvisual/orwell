defmodule Orwell.GitHub.References do
  @moduledoc """
  A wrapper to `Tentacat.References` using our own `Config`
  """

  alias Tentacat.References

  import Orwell.GitHub.Config

  @spec find(binary) :: Tentacat.response
  def find(ref) do
    References.find(owner(), repo(), ref, client())
  end

  @spec create(list | map) :: Tentacat.response
  def create(body) do
    References.create(owner(), repo(), body, client())
  end
end
