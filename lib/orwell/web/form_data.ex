defimpl Phoenix.HTML.FormData, for: Orwell.Post do
  def input_value(post, _form, field), do:
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

  def to_form(_data, _orm, _field, _options) do
    # TODO
    # not needed so far
  end

  def input_validation(_data, _form, _field) do
    # TODO
    # not needed so far
  end

  def input_type(_data, _form, _field) do
    # TODO
    # not needed so far
  end

  def input_validations(_data, _form, _field) do
    # TODO
    # not needed so far
  end
end
