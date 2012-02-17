# encoding: utf-8

module Concern
  module Audit
    module Author

      def self.current=(author)
        Thread.current[:current_author] = author
      end

      def self.current
        Thread.current[:current_author]
      end

    end
  end
end