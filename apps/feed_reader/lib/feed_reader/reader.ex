defmodule FeedReader.Reader do
  use GenServer

  @wait_time 0

  def start_link() do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def get_site(pid, url) do
    GenServer.cast(pid, {:get_site, url})
  end

  def init(_) do
    {:ok, %{site: nil, feed: nil}}
  end

  def handle_cast({:get_site, url}, state) do
    Process.send_after(self(), :get_feed, @wait_time)
    {:noreply, %{state | site: Scrape.website(url)}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:get_feed, %{site: %{feeds: feeds}} = state) do
    feed = Enum.flat_map(feeds, fn feed ->
      Scrape.feed(feed)
    end)
    {:noreply, %{state | feed: feed}}
  end
end
