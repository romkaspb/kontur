class DestroyAdminNewsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    News.where(owner: :admin).destroy_all
    $redis_news.del("current")
    @news = News.current
    ActionCable.server.broadcast("news", news: @news.as_json)
  end
end
