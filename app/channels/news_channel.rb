class NewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "news"
    news = News.current

    ActionCable.server.broadcast("news", news: news.as_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
