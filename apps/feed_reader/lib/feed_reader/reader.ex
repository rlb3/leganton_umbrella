defmodule FeedReader.Reader do
  use GenServer

  @wait_time 0

  def start_link() do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def fetch_site(pid, url) do
    GenServer.cast(pid, {:fetch_site, url})
  end

  def get_site(pid) do
    GenServer.call(pid, :site)
  end

  def get_feed(pid) do
    GenServer.call(pid, :feed)
  end

  def init(_) do
    {:ok, %{site: nil, feed: nil}}
  end

  def handle_cast({:fetch_site, url}, state) do
    Process.send_after(self(), :get_feed, @wait_time)
    {:noreply, %{state | site: Scrape.website(url)}}
  end

  def handle_call(:site, _from, state) do
    {:reply, state.site, state}
  end

  def handle_call(:feed, _from, state) do
    {:reply, state.feed, state}
  end

  def handle_info(:get_feed, %{site: %{feeds: feed_urls}} = state) do
    feed = Enum.flat_map(feed_urls, fn url -> Scrape.feed(url) end)
    {:noreply, %{state | feed: feed}}
  end
end
