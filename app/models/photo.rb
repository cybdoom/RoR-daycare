class Photo < ActiveRecord::Base
	include Shared::AttachmentHelper

	belongs_to :photoable, polymorphic: true

	has_attachment :image, styles: { medium: "250x250>", thumb: "158x1128>" }#, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image, presence: true, content_type: /\Aimage\/.*\Z/
end
