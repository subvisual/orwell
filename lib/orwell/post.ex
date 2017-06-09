defmodule Orwell.Post do
  defstruct title: nil, body: nil

  @type t :: %__MODULE__{
    title: String.t,
    body: String.t
  }

  @spec new(String.t, String.t) :: t
  def new(title, body) do
    %__MODULE__{title: title, body: body}
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
