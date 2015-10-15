module Shared
  module AttachmentHelper

    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def has_attachment(name, options = {})

        # generates a string containing the singular model name and the pluralized attachment name.
        # Examples: "user_avatars" or "asset_uploads" or "message_previews"

        attachment_folder = "/images"

        # I want to create a path for the upload that looks like:
        # message_previews/00/11/22/001122deadbeef/thumbnail.png
        attachment_path     = "#{attachment_folder}/:id/:style/:filename"

        # if Rails.env.production?
        #   options[:path]            ||= attachment_path
        #   options[:storage]         ||= :s3
        #   options[:s3_credentials]  ||= File.join(Rails.root, 'config', 's3.yml')
        #   options[:s3_protocol]     ||= 'https'
        # else
          # For local Dev/Test envs, use the default filesystem, but separate the environments
          # into different folders, so you can delete test files without breaking dev files.
          options[:path]  ||= ":rails_root/public:url"
          options[:url]   ||= "/system/:class/:attachment/:id_partition/:style/:filename"
          options[:url_generator] ||= Paperclip::UrlGenerator
        # end

        # pass things off to paperclip.
        has_attached_file name, options
      end
    end
  end
end
