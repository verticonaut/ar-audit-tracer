module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter < AbstractAdapter

      def add_authorstamps_sql(table_name)
        [add_column_sql(table_name, :created_by, :string), add_column_sql(table_name, :updated_by, :string)]
      end

      def remove_authorstamps_sql(table_name)
        [remove_column_sql(table_name, :updated_by), remove_column_sql(table_name, :created_by)]
      end

    end
  end
end
