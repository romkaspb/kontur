class NewsController < ApplicationController
  before_action :set_news

  # GET /news
  # GET /news.json
  def show
    render :index
  end

  # POST /news
  # POST /news.json
  def create
    update
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    if @news.update(news_params)
      DestroyAdminNewsJob.set(wait_until: @news.publicated_until).perform_later
    end
    show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.where(owner: :admin).first || News.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:title, :annotation, :publicated_until)
    end
end
