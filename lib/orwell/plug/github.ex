defmodule Orwell.Plug.GitHub do
  @moduledoc """
  Defines a helper to provide easy access to a GitHub client instance
  based on the currently logged in user
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    token = current_user.github_credentials["token"]
    config = Orwell.GitHub.Config.new(token)

    conn
    |> assign(:github_config, config)
  end
end
