module YandexNewsParser
	# список css селекторов, где может содержаться текст
	TEXT_CONTAINERS = ['.rich-text__piece', '.doc__text']

	def self.first_news
		page = Nokogiri::HTML(open("https://yandex.ru/"))
		news_page_url = page.css('.list__item-content').first['href']

		if news_page_url.present?
			new_page = Nokogiri::HTML(open(news_page_url))
			title = new_page.css('h1').text
			text = ""
			TEXT_CONTAINERS.each do |t|
				text = new_page.css(t).text
				break unless text.empty?
			end

			unparsed_date = new_page.css('.story__group:not(.story__group_type_root)').first.css('.doc__time').text
			parsed_date = date_humanize( unparsed_date )

			return title, text, parsed_date
		end

		nil
	end

	private
	def self.date_humanize( unparsed )
		datepart_to_time = {
			'сегодня' 		=> Time.zone.now.beginning_of_day,
			'вчера' 		=> 1.day.ago.beginning_of_day
		}

		if unparsed =~ /\s/
			unparsed_day, none, time = unparsed.split('\s')
		else
			unparsed_day, time = 'сегодня', unparsed
		end
		parsed = datepart_to_time[unparsed_day]

		if parsed.present?
			parsed = Time.zone.parse(time, parsed)
		end

		parsed
	end
end
