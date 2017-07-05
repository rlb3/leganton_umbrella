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
    field :add_site, type: :job_created do
      arg :url, non_null(:string)

      resolve fn %{url: url}, _context ->
        Que.add(Leganton.Web.AddSiteWorker, url)

        {:ok, %{status: :started}}
      end
    end

    field :mark_read, type: :entry do
      arg :id, :id

      resolve fn %{id: id}, _context ->
        Leganton.Entry
        |> Leganton.Repo.get(id)
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

  object :job_created do
    field :status, :job_status
  end

  enum :job_status do
    value :started
  end
end
