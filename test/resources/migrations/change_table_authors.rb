class ChangeTableAuthors < ActiveRecord::Migration

  def self.up

    change_table :blank_ones do |t|
      t.authorstamps(:integer, :null => true)
    end

  end

end
