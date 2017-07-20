defmodule Orwell.Web.AuthController do
  use Orwell.Web, :controller

  plug Ueberauth

  alias Orwell.Session
  alias Ueberauth.Strategy.Helpers, as: AuthHelpers

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  def request(conn, _params) do
    redirect conn, external: AuthHelpers.callback_url(conn)
  end

  def callback(
    %{assigns: %{ueberauth_auth: auth}} = conn,
    %{"provider" => "github"})
  do

    case Session.find_for_github(auth) do
      {:ok, user} ->
        {:ok, updated_user} = update_user(user, auth)
        name = updated_user.name || updated_user.github_uid

        conn
        |> Guardian.Plug.sign_in(updated_user, :access)
        |> put_flash(:info, "Welcome " <> name)
        |> redirect(to: "/")

      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")
    end
  end

  def update_user(
    user,
    %{credentials: credentials, info: %{name: name} = info}
  ) do
    import Ecto.Changeset
    alias Orwell.Repo

    change(user)
    |> put_change(:name, name)
    |> put_change(:github_credentials, Map.from_struct(credentials))
    |> put_change(:github_info, Map.from_struct(info))
    |> Repo.update
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to be authenticated.")
    |> redirect(to: "/")
  end
end
