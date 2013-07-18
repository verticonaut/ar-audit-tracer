
module ActiveRecord
  # = Active Record Authorstamp
  #
  # Active Record automatically stamps the user that performns create and update operations if the
  # table has fields named <tt>created_by/created_by_id</tt> or
  # <tt>updated_by/updated_by</tt>.
  # The user identifier is taken from ActiveRecord::Audit::Author.current. The respective value must be set
  # by the user of this feater by calling ActiveRecord::Audit::Author.current = 'some_value'
  #
  # Userstamping can be turned off by setting:
  #
  #   config.active_record.record_userstamps = false
  #
  module AuthorStamp
    extend ActiveSupport::Concern

    included do
      class_attribute :record_authorstamps
      self.record_authorstamps = true
    end

    def initialize_dup(other) # :nodoc:
      clear_authorstamp_attributes
      super
    end

  private

    def create_record
      if self.record_authorstamps
        all_authorstamp_attributes.each do |column|
          if respond_to?(column) && respond_to?("#{column}=") && self.send(column).nil?
            write_attribute(column.to_s, current_author)
          end
        end
      end

      super
    end

    def update_record(*args)
      if should_record_authorstamps?
        authorstamp_attributes_for_update_in_model.each do |column|
          column = column.to_s
          next if attribute_changed?(column)
          write_attribute(column, current_author)
        end
      end
      super
    end

    def should_record_authorstamps?
      self.record_authorstamps && (!partial_writes? || changed? || (attributes.keys & self.class.serialized_attributes.keys).present?)
    end

    def authorstamp_attributes_for_create_in_model
      authorstamp_attributes_for_create.select { |c| self.class.column_names.include?(c.to_s) }
    end

    def authorstamp_attributes_for_update_in_model
      authorstamp_attributes_for_update.select { |c| self.class.column_names.include?(c.to_s) }
    end

    def all_authorstamp_attributes_in_model
      authorstamp_attributes_for_create_in_model + authorstamp_attributes_for_update_in_model
    end

    def authorstamp_attributes_for_update
      [:updated_by, :updated_by_id]
    end

    def authorstamp_attributes_for_create
      [:created_by, :created_by_id]
    end

    def all_authorstamp_attributes
      authorstamp_attributes_for_create + authorstamp_attributes_for_update
    end

    def current_author
      Concern::Audit::Author.current
    end

    # Clear attributes and changed_attributes
    def clear_authorstamp_attributes
      all_authorstamp_attributes_in_model.each do |attribute_name|
        self[attribute_name] = nil
        changed_attributes.delete(attribute_name)
      end
    end
  end
end
