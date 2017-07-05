defmodule Orwell.Session do
  alias Orwell.{Repo, User}

  import Ecto.Query

  @uid_whitelist ~w(
    naps62
    fribmendes
    azevedo-252
    fcbaila
    gabrielpoca
    joaojusto
    johnny1337
    rmdmachado
    ronaldofs
    zamith
    lauraesteves
    pfac
  )

  def find_for_github(%{credentials: credentials, uid: uid}) do
    existing_user = find_existing(uid)

    cond do
      existing_user ->
        {:ok, existing_user}
      Enum.member?(@uid_whitelist, uid) ->
        create_whitelisted_user(uid)
      true ->
        {:error, "User not allowed. Does he belong to Subvisual?"}
    end
  end

  defp find_existing(uid) do
    User
    |> where([u], u.github_uid == ^uid)
    |> Repo.one
  end

  defp create_whitelisted_user(uid) do
    %User{github_uid: uid}
    |> Repo.insert
  end
end
