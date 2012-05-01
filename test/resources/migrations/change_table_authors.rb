class ChangeTableAuthors < ActiveRecord::Migration

  def up

    change_table :blank_ones do |t|
      t.authors(:integer, :null => true)
    end

  end

end
