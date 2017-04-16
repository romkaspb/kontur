App.news = App.cable.subscriptions.create "NewsChannel",
	connected: ->
	    @current
	received: (data) ->
		@set_news data
	current: ->
		@perform("current")

	set_news: (data) ->
    if data.news
   		$("h1").text data.news.title
   		$("#annotation").text data.news.annotation
   		$("#created_at").text data.news.created_at
