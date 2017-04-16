class NewsSerializer < ActiveModel::Serializer
  attributes :title, :annotation

  attribute :created_at do
  	I18n.l object.created_at, format: :long
  end
end
