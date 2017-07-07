defmodule Orwell.Post do
  defstruct id: :new, title: nil, body: nil, cover_url: nil, retina_cover_url: nil, tags: nil, intro: nil

  @type t :: %__MODULE__{
    id: integer,
    title: String.t,
    body: String.t,
    cover_url: String.t,
    retina_cover_url: String.t,
    tags: list(String.t),
    intro: String.t,
  }

  use Vex.Struct
  validates :id, [presence: true]
  validates :title, [presence: true]
  validates :body, [presence: true]
  validates :cover_url, [presence: true]
  validates :retina_cover_url, [presence: true]
  validates :intro, [presence: true]
  validates :tags, [format: ~r/^\w+(\s*,\s*\w+)*$/]

  def valid?(post), do: Vex.valid?(post)
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

  @spec yaml_front_matter(t) :: String.t
  def yaml_front_matter(%__MODULE__{title: title}) do
    """
    ---
    title: "#{title}"
    ---
    """
  end
end

