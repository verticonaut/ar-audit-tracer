# encoding: utf-8
require 'active_record/migration/command_recorder'
require 'active_record/author_stamp'
require 'concern/audit/author'

module ActiveRecord


  module ConnectionAdapters
    module SchemaStatements
      # Adds author columns (created_by and updated_by) to the named table.
      # ===== Examples
      #  add_authors(:suppliers)
      def add_authorstamps(table_name, type=:string, *args)
        options = {:null => false}.merge(args.extract_options!)
        add_column table_name, :created_by, type, options
        add_column table_name, :updated_by, type, options
      end

      # Removes the author columns (created_by and updated_by) from the table definition.
      # ===== Examples
      #  remove_authors(:suppliers)
      def remove_authorstamps(table_name)
        remove_column table_name, :updated_by
        remove_column table_name, :created_by
      end
    end


    class TableDefinition

      # Creates author columns ...
      #
      # @param Symbol type  The desired type for the columns, defaults to :string
      # @param Hash   *args Column options from rails
      def authorstamps(type=:string, *args)
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
      def authorstamps(type=:string, *args)
        options = {:null => false}.merge(args.extract_options!)
        @base.add_authorstamps(@table_name, type, options)
      end

      # Removes the author columns (created_by and updated_by) from the table.
      # ===== Example
      #  t.remove_authors
      def remove_authorstamps
        @base.remove_authorstamps(@table_name)
      end

    end

  end


  Base.class_eval do
    include ActiveRecord::AuthorStamp
  end

end


