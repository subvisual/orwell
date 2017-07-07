defmodule Orwell.GitHub.Config do
  @moduledoc """
  A wrapper for GitHub related configuration
  """

  alias Tentacat.Client

  defstruct [:owner, :repo, :client]

  @type t :: %__MODULE__{owner: String.t, repo: String.t, client: Client.t}

  @spec new(String.t) :: t
  def new(token) do
    %__MODULE__{
      owner: owner(),
      repo: repo(),
      client: client(token)
    }
  end

  @spec owner :: String.t
  def owner, do: Application.get_env(:orwell, :github_owner)

  @spec repo :: String.t
  def repo, do: Application.get_env(:orwell, :github_repo)

  @spec client(String.t) :: Client.t
  def client(token), do: %{access_token: token} |> Client.new
end
