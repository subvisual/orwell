defmodule Orwell.GitHub.Blog do
  @moduledoc """
  A wrapper for the Blog repository configurations.
  """

  @spec titleize(String.t) :: String.t
  def titleize(filename) do
    ~r/([a-z]+[\w-]+).md/
    |> Regex.run(filename, capture: :all_but_first)
    |> List.first
    |> String.split("-")
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @spec post_path :: String.t
  def post_path do
    [year, month, full_month] = formatted_date()
    formatted_month = "#{month}-#{full_month}"

    Path.join([posts_dir(), year, formatted_month])
  end

  @spec post_path(String.t) :: String.t
  def post_path(filename), do: post_path() |> Path.join(filename)

  @spec posts_dir :: String.t
  def posts_dir,
    do: Application.get_env(:orwell, :github_posts_dir)

  @spec formatted_date :: String.t
  defp formatted_date do
    Date.utc_today
    |> Timex.format!("{YYYY}-{0M}-{Mfull}")
    |> String.split("-")
    |> Enum.map(&String.downcase/1)
  end
end
