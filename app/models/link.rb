class Link < ApplicationRecord
  belongs_to :content_module

  enum :link_type, { survey: "survey", game: "game" }, validate: true

  validates :title, :url, :link_type, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/.+\z/i, message: "must start with http:// or https://" }, allow_blank: true

  default_scope { order(:position) }
end
