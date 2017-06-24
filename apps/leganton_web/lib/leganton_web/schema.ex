defmodule Leganton.Web.Schema do
  use Absinthe.Schema
  use Absinthe.Ecto, repo: Leganton.Repo
  import Ecto.Query

  query do
    field :sites, list_of(:site) do
      resolve fn _arg, _context ->
        {:ok, Leganton.Repo.all(Leganton.Site)}
      end
    end

    field :entries, list_of(:entry) do
      resolve fn _arg, _context ->
        entries = from e in Leganton.Entry,
          where: e.read == false
        {:ok, Leganton.Repo.all(entries)}
      end
    end
  end

  mutation do
    field :add_site, type: :site do
      arg :url, non_null(:string)

      resolve fn %{url: url}, _context ->
        {:ok, pid} = FeedReader.Reader.start_link
        FeedReader.Reader.fetch_site(pid, url)

        {:ok, site} =
          FeedReader.Reader.get_site(pid)
          |> Map.from_struct
          |> (&(Leganton.Site.changeset(%Leganton.Site{}, &1))).()
          |> Leganton.Repo.insert

        FeedReader.Reader.get_feed(pid)
        |> Enum.each(fn feed ->
          Ecto.build_assoc(site, :entries)
          |> Leganton.Entry.changeset(feed)
          |> Leganton.Repo.insert
        end)
        {:ok, site}
      end
    end

    field :mark_read, type: :entry do
      arg :id, :id

      resolve fn %{id: id}, _context ->
        Leganton.Repo.get(Leganton.Entry, id)
        |> Leganton.Entry.changeset(%{read: true})
        |> Leganton.Repo.update
      end
    end
  end

  object :site do
    field :id, :id
    field :title, :string
    field :description, :string
    field :url, :string
    field :entries, list_of(:entry), resolve: assoc(:entries)
  end

  object :entry do
    field :id, :id
    field :title, :string
    field :description, :string
    field :url, :string
    field :url, :date
    field :read, :boolean
  end
end
