module ActiveRecord
  class Migration
    # <tt>ActiveRecord::Migration::CommandRecorder</tt> records commands done during
    # a migration and knows how to reverse those commands. The CommandRecorder
    # knows how to invert the following commands:
    #
    # Adds...
    # * add_authorstamps
    # * remove_authorstamps
    class CommandRecorder

      [ # irreversible methods need to be here too
        :add_authorstamps,
        :remove_authorstamps,
      ].each do |method|
        class_eval <<-EOV, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)          # def create_table(*args, &block)
            record(:"#{method}", args, &block)  #   record(:create_table, args, &block)
          end                                   # end
        EOV
      end

      module StraightReversions
        private
        { add_authorstamps:  :remove_authorstamps }.each do |cmd, inv|
          [[inv, cmd], [cmd, inv]].uniq.each do |method, inverse|
            class_eval <<-EOV, __FILE__, __LINE__ + 1
              def invert_#{method}(args, &block)    # def invert_create_table(args, &block)
                [:#{inverse}, args, block]          #   [:drop_table, args, block]
              end                                   # end
            EOV
          end
        end
      end

      include StraightReversions

    end
  end
end
