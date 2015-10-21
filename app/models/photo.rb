# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  photoable_id       :integer
#  photoable_type     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Photo < ActiveRecord::Base
	include Shared::AttachmentHelper

	belongs_to :photoable, polymorphic: true

	has_attachment :image, styles: { medium: "250x250>", thumb: "158x1128>" }#, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image, presence: true, content_type: /\Aimage\/.*\Z/
end
