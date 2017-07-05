defmodule Leganton.Web.AddSiteWorker do
  use Que.Worker

  def perform(url) do
    [site: site_struct, feed: feed_struct] = FeedReader.Reader.fetch(url)

    {:ok, site} =
      site_struct
      |> Map.from_struct
      |> (&(Leganton.Site.changeset(%Leganton.Site{}, &1))).()
      |> Leganton.Repo.insert

    feed_struct
    |> Enum.each(fn feed ->
      Ecto.build_assoc(site, :entries)
      |> Leganton.Entry.changeset(feed)
      |> Leganton.Repo.insert
    end)
  end

  def on_failure(args, error) do
    IO.inspect(args)
    IO.inspect(error)
  end
end
