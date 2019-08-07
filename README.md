# Orwell

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Writting


### 1. Write it

There's currently no UI to write posts in our blog directly.

Instead, we recommend writing them in your favorite text editor, preferably one
that has markdown support. A few suggestions:

- [draftin.com](draftin.com)
- [drive.google.com](docs.google.com)
- [notion.so](notions.so)

### 2. Create a post file

Create a file in this repo with the following path and name:

```
pages/posts/<YYYY>/<MM-MMMM>/<ID>-<TITLE>.md
```

Replacing each of the following fields:

- `<YYYY>` should be the current year (e.g.: 2017)
- `<MM-MMMM>` should be the current month, both in numerical and named form
    (e.g.: 01-january)
- `<ID>` should be a unique numerical ID for your post. Check the most recent
    post's id and add one to it
- `<TITLE>` the title of your post, in lowercase, no accents, no special
    characters, and without
    spaces. (i.e.: `Typography as Base: From the Content Out` becomes
    `typography-as-base-from-the-content-out`)

So a full path example could be:

```
pages/posts/2017/06-june/138-typography-as-base-from-the-content-out.md
```

### 3. Fill the file

Copy the contents from our [markdown post template](docs/markdown-post-template.md)
and replace the placeholders. Most of them are the same as indicated in the
previous step, but there are few new ones:

- `<AUTHOR>` this should be your author slug (so `miguel-palhas` and not `Miguel
    Palhas`). Check `data/authors.yml` to see what yours is
- `<DD/MM/YYYY>` the date of publication, in the specified format
- `<OPTIONAL-COVER>` the image url for your cover image. This is optional, and
    should be hosted on our amazon bucket. Talk to a developer to handle this
- `<OPTIONAL-RETINA-COVER>` same as above, but for the retina version of the
    image. Optional as well, but you provide a regular cover, a retina one
    should also be provided.
- `<TAG>` a tag for your post (e.g: "general", or "community"). Please specify
at least one of the main tags (general, development, design and community), and
optionally a couple of secondary ones (e.g.: "elixir", "vim")
- `<INTRO>` a small paragraph to serve as intro to your post. you can use
    markdown here as well

Below the `---` block, paste in your post content.
Do not use primary headers (`#` in markdown), since the primary header will
already be your main title.

### 4. Publish

Make sure the post is rendering properly (talk to a developer if needed), and
commit the new file to `master`.

### 5. Celebrate

Go grab a beer. You deserve it.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
