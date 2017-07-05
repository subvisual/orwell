defmodule Orwell.Web.AuthController do
  use Orwell.Web, :controller

  plug Ueberauth

  alias Orwell.Session

  def callback(
    %{assigns: %{ueberauth_auth: auth}} = conn,
    %{"provider" => "github"})
  do

    case Session.find_for_github(auth) do
      {:ok, user} ->
        {:ok, updated_user} = update_user(user, auth)

        conn
        |> Guardian.Plug.sign_in(updated_user, :access)
        |> put_flash(:info, "Welcome " <> updated_user.name)
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
end
