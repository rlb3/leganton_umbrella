defmodule FeedReader.Reader do
  def fetch(url) do
    with {:ok, site} <- fetch_site(url),
         {:ok, feed} <- fetch_feed(site),
      do: [site: site, feed: feed]
  end

  defp fetch_site(url) do
    {:ok, Scrape.website(url)}
  end

  defp fetch_feed(%Scrape.Website{feeds: feed_urls} ) do
    feed = Enum.flat_map(feed_urls, fn url -> Scrape.feed(url) end)
    {:ok, feed}
  end
end
