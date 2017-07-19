defmodule Orwell.Post do
  defstruct [:id, :path, :title, :body, :author, :date,
             :cover_url, :retina_cover_url, :tags, :intro]

  @type t :: %__MODULE__{
    id: integer,
    path: String.t,
    title: String.t,
    body: String.t,
    author: String.t,
    date: String.t,
    cover_url: String.t,
    retina_cover_url: String.t,
    tags: list(String.t),
    intro: String.t,
  }

  use Vex.Struct
  validates :id, by: &is_integer/1
  validates :title, presence: true
  validates :author, presence: true
  validates :date, format: ~r|^\d{2}/\d{2}/\d{4}$|
  validates :body, presence: true
  validates :cover_url, presence: true
  validates :retina_cover_url, presence: true
  validates :intro, presence: true
  validates :tags, format: ~r/^\w+(\s*,\s*\w+)*$/

  def errors(post), do: Vex.errors(post)

  @spec new() :: t
  def new, do: %__MODULE__{}

  @spec from_params(map) :: t
  def from_params(params) do
    params
    |> Enum.reduce(%__MODULE__{}, fn({key, value}, post) ->
      Map.put(post, String.to_atom(key), value)
    end)
  end

  @spec full_file(t) :: String.t
  def full_file(%__MODULE__{body: body} = post) do
    yaml_front_matter(post) <> "\n" <> body <> "\n"
  end

  @spec formatted_utc_today() :: String.t
  def formatted_utc_today() do
    Date.utc_today
    |> Timex.format!("{0D}/{0M}/{YYYY}")
  end

  @spec yaml_front_matter(t) :: String.t
  def yaml_front_matter(%__MODULE__{
    id: id,
    path: path,
    title: title,
    author: author,
    date: date,
    cover_url: cover_url,
    retina_cover_url: retina_cover_url,
    tags: tags,
    intro: intro
  }) do
    """
    ---
    id: #{id}
    path: #{path}
    title: "#{title}"
    author: #{author}
    date: #{date}
    cover: #{cover_url}
    retina_cover: #{retina_cover_url}
    tags:
    #{tags |> String.split(",") |> Enum.map(&String.trim/1) |> yaml_list}
    intro: "#{intro}"
    ---
    """
  end

  @spec yaml_list(List) :: String.t
  defp yaml_list(list) do
    list
    |> Stream.map(&("  - " <> &1))
    |> Enum.join("\n")
  end
end
