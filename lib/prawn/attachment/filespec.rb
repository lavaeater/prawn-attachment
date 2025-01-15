# frozen_string_literal: true

require "digest"

module Prawn
  module Attachment
    # FileSpec corresponds to the PDF file specification object.
    class Filespec
      attr_reader :file_name

      def initialize(file, options = {})
        hexdigest = Digest.hexencode(file.data[:Params][:CheckSum])
        name = options[:name] || hexdigest

        @file_name = PDF::Core::LiteralString.new(name)

        if options[:description]
          desc_str = options[:description].to_s
          @description = PDF::Core::LiteralString.new(desc_str)
        end

        @hidden = options[:hidden]

        if options[:relationship]
          @relationship = options[:relationship]
        end
        @file = file
      end

      def hidden?
        @hidden
      end

      def build_pdf_object(document)
        obj = document.ref!(
          Type: :Filespec,
          F: file_name,
          EF: { F: file, UF: file },
          UF: file_name
        )

        obj.data[:Desc] = description if description
        obj.data[:AFRelationship] = relationship if relationship
        obj
      end

      private

      attr_reader :file, :description, :relationship
    end
  end
end
