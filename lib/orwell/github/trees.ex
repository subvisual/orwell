defmodule Orwell.GitHub.Trees do
  @moduledoc """
  A wrapper to `Tentacat.Trees` using our own `Config`
  """

  alias Tentacat.Trees

  import Orwell.GitHub.Config

  @spec find_recursive(binary) :: Tentacat.response
  def find_recursive(ref) do
    Trees.find_recursive(owner(), repo(), ref, client())
  end
end
