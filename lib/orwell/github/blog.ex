defmodule Orwell.GitHub.Blog do
  @moduledoc """
  A wrapper for the Blog repository configurations.
  """

  @post_title_regex ~r/([a-z]+[\w-]+).md/

  @spec titleize(String.t) :: String.t
  def titleize(filename) do
    @post_title_regex
    |> Regex.run(filename, capture: :all_but_first)
    |> List.first
    |> String.split("-")
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @spec to_filename(String.t, Integer) :: String.t
  def to_filename(title, id) do
    [id, title]
    |> Enum.join("-")
    |> String.downcase
    |> String.replace(" ", "-")
    |> String.replace_suffix("", ".md")
  end

  @spec post_path :: String.t
  def post_path do
    [year, month, full_month] = formatted_date()
    formatted_month = "#{month}-#{full_month}"

    Path.join([posts_dir(), year, formatted_month])
  end

  @spec post_path(String.t) :: String.t
  def post_path(filename), do: post_path() |> Path.join(filename)

  @spec post_url(String.t) :: String.t
  def post_url(filename), do: post_base_url() |> Path.join(filename)

  @spec posts_dir :: String.t
  def posts_dir,
    do: Application.get_env(:orwell, :github_posts_dir)

  @spec post_base_url :: String.t
  def post_base_url,
    do: Application.get_env(:orwell, :post_base_url)

  @post_id_regex ~r|/(?<id>[0-9]+)[^/]*$|

  @spec post_id(String.t) :: String.t
  def post_id(path) do
    case Regex.named_captures(@post_id_regex, path) do
      %{"id" => id} ->
        id
        |> Integer.parse
        |> elem(0)
      _ ->
        IO.puts "Well, fuck me dead! I tried to figure out the post id for \"#{path}\", but wasn't able to. Did the devs mess up my RegEx? I blame @fribmendes! BLOOP BLEEP"
        nil
    end
  end

  @spec formatted_date :: String.t
  defp formatted_date do
    Date.utc_today
    |> Timex.format!("{YYYY}-{0M}-{Mfull}")
    |> String.split("-")
    |> Enum.map(&String.downcase/1)
  end
end
