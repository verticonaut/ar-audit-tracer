# encoding: utf-8
require 'concern/audit/author'

module ActiveRecord

  # = Active Record Author
  #
  # Active Record automatically authors create and update operations if the
  # table has fields named <tt>created_by</tt> or
  # <tt>updated_by</tt>.
  #
  # Authoring can be turned off by setting:
  #
  #   <tt>ActiveRecord::Base.record_authors = false</tt>
  module Author
    extend ActiveSupport::Concern

    included do
      class_attribute :record_authors
      self.record_authors = true
    end

    def initialize_dup(other)
      clear_author_attributes
    end

  private

    def create #:nodoc:
      if self.record_authors
        current_author = Concern::Audit::Author.current

        all_author_attributes.each do |column|
          if respond_to?(column) && self.send(column).nil?
            write_attribute(column.to_s, current_author)
          end
        end
      end

      super
    end

    def update(*args) #:nodoc:
      if should_record_authors?
        current_author = Concern::Audit::Author.current

        author_attributes_for_update_in_model.each do |column|
          column = column.to_s
          next if attribute_changed?(column)
          write_attribute(column, current_author)
        end
      end
      super
    end

    def should_record_authors?
      self.record_authors && (!partial_updates? || changed? || (attributes.keys & self.class.serialized_attributes.keys).present?)
    end

    def author_attributes_for_update_in_model
      author_attributes_for_update.select { |c| respond_to?(c) }
    end

    def author_attributes_for_create_in_model
      author_attributes_for_create.select { |c| respond_to?(c) }
    end

    def all_author_attributes
      author_attributes_for_create + author_attributes_for_update
    end

    def author_attributes_for_update #:nodoc:
      [:updated_by]
    end

    def author_attributes_for_create #:nodoc:
      [:created_by]
    end

    def all_author_attributes_in_model
      author_attributes_for_create_in_model + author_attributes_for_update_in_model
    end

    # Clear attributes and changed_attributes
    def clear_author_attributes
      all_author_attributes_in_model.each do |attribute_name|
        self[attribute_name] = nil
        changed_attributes.delete(attribute_name)
      end
    end

  end



  module ConnectionAdapters
    module SchemaStatements
      # Adds author columns (created_by and updated_by) to the named table.
      # ===== Examples
      #  add_authors(:suppliers)
      def add_authors(table_name, type=:string)
        add_column table_name, :created_by, type, :null => false
        add_column table_name, :updated_by, type, :null => false
      end

      # Removes the author columns (created_by and updated_by) from the table definition.
      # ===== Examples
      #  remove_authors(:suppliers)
      def remove_authors(table_name)
        remove_column table_name, :updated_by
        remove_column table_name, :created_by
      end
    end


    class TableDefinition

      # Creates author columns ...
      #
      # @param Symbol type  The desired type for the columns, defaults to :string
      # @param Hash   *args Column options from rails
      def authors(type=:string, *args)
        options = args.extract_options!
        column(:created_by, type, options)
        column(:updated_by, type, options)
      end

    end

    class Table
      # Adds author (created_by and updated_by) columns to the table
      # ===== Example
      #  t.authors
      #
      # @param Symbol type  The desired type for the columns, defaults to :string
      # @see SchemaStatements#add_authors
      def authors(type=:string)
        @base.add_authors(@table_name, type)
      end

      # Removes the author columns (created_by and updated_by) from the table.
      # ===== Example
      #  t.remove_authors
      def remove_authors
        @base.remove_authors(@table_name)
      end

    end

  end


  Base.class_eval do
    include Author
  end

end


