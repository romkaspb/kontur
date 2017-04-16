class News < ApplicationRecord
	enum owner: [:admin, :yandex]

	scope :admin_news, -> { where(owner: 0).where("publicated_until > ?", Time.zone.now) }
	scope :yandex_news, -> { where(owner: 1) }

	validates :title, :annotation, 	presence: true
	validates :publicated_until, 	presence: true, if: Proc.new{ owner == "admin" }
	validate :publicated_until_cannot_be_in_past

	after_save 		:set_showable_news

	def self.current
		current_news = $redis_news.get("current")
		if current_news
			@news = Marshal.load(current_news)
		else
			@news = admin_news.first || yandex_news.first || create_yandex_news
		end
		$redis_news.set("current", Marshal.dump(@news))

		@news
	end

	def self.create_yandex_news
		(title, annotation, date) = YandexNewsParser.first_news
		@news = News.new( title: title, annotation: annotation, created_at: date, owner: :yandex )
		@news.save ? @news : nil
	end

	def set_showable_news
		$redis_news.set("current", Marshal.dump(self))
		ActionCable.server.broadcast("news", news: self.as_json)
	end

	def publicated_until_cannot_be_in_past
		if publicated_until.present? and publicated_until < Time.zone.now
			errors.add(:publicated_until, " cannot be in past")
		end
	end
end
