defimpl Phoenix.HTML.FormData, for: Orwell.Post do
  def input_value(post, form, field), do:
    Map.get(post, field)

  def to_form(post, options) do
    %Phoenix.HTML.Form{
      source: post,
      impl: __MODULE__,
      id: "post",
      name: "post",
      params: %{},
      options: options,
    }
  end
end
