defmodule Orwell.GitHub.Config do
  @moduledoc """
  A wrapper for GitHub related configuration
  """

  alias Tentacat.Client

  @spec owner :: String.t
  def owner, do: Application.get_env(:orwell, :github_owner)

  @spec repo :: String.t
  def repo, do: Application.get_env(:orwell, :github_repo)

  @spec client :: Client.t
  def client do
    token = Application.get_env(:orwell, :github_token)
    %{access_token: token} |> Client.new
  end
end
