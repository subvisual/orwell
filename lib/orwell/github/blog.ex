defmodule Orwell.GitHub.Blog do
  @moduledoc """
  A wrapper for the Blog repository configurations.
  """

  @spec post_path :: String.t
  def post_path do
    [year, month, full_month] = formatted_date()
    formatted_month = "#{month}-#{full_month}"

    Path.join([post_path_prefix(), year, formatted_month])
  end

  @spec post_path(String.t) :: String.t
  def post_path(filename), do: post_path() |> Path.join(filename)

  @spec formatted_date :: String.t
  defp formatted_date do
    Date.utc_today
    |> Timex.format!("{YYYY}-{0M}-{Mfull}")
    |> String.split("-")
    |> Enum.map(&String.downcase/1)
  end

  @spec post_path_prefix :: String.t
  defp post_path_prefix,
    do: Application.get_env(:orwell, :github_post_path_prefix)
end
